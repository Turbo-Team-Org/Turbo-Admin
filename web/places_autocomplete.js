// Google Places Autocomplete JS for Flutter Web
// Using the new PlaceAutocompleteElement API (replaces deprecated Autocomplete)
// Migration guide: https://developers.google.com/maps/documentation/javascript/places-migration-overview

// Wait for Google Maps API to be ready
function waitForGoogleMaps(callback, maxAttempts = 50) {
  let attempts = 0;
  const checkInterval = setInterval(function() {
    attempts++;
    if (typeof google !== 'undefined' && 
        google.maps && 
        google.maps.places && 
        (google.maps.places.PlaceAutocompleteElement || customElements.get('gmp-place-autocomplete'))) {
      clearInterval(checkInterval);
      callback();
    } else if (attempts >= maxAttempts) {
      clearInterval(checkInterval);
      console.error('Google Maps Places API failed to load after', maxAttempts, 'attempts');
      callback(); // Still try to proceed, might fall back to legacy
    }
  }, 100);
}

window.initPlacesAutocomplete = function(inputId) {
  const input = document.getElementById(inputId);
  if (!input) {
    console.error('Input element not found:', inputId);
    return;
  }
  
  // Wait for Google Maps API to be fully loaded
  waitForGoogleMaps(function() {
    if (typeof google === 'undefined' || !google.maps || !google.maps.places) {
      console.error('Google Maps Places API not loaded');
      return;
    }
    
    // Check if the new API is available (either as class or web component)
    const hasNewAPI = google.maps.places.PlaceAutocompleteElement || 
                      customElements.get('gmp-place-autocomplete');
    
    if (hasNewAPI) {
      try {
        // Create the autocomplete element using the new web component API
        const autocompleteElement = document.createElement('gmp-place-autocomplete');
        
        // Configure the element properties
        if (autocompleteElement.requestedResultTypes !== undefined) {
          autocompleteElement.requestedResultTypes = ['geocode'];
        }
        
        // Set styling
        autocompleteElement.style.width = '100%';
        autocompleteElement.style.height = '100%';
        autocompleteElement.style.display = 'block';
        
        // Copy input styles to maintain appearance
        const computedStyle = window.getComputedStyle(input);
        autocompleteElement.style.fontSize = computedStyle.fontSize || '16px';
        autocompleteElement.style.padding = computedStyle.padding || '8px';
        autocompleteElement.style.border = computedStyle.border || '1px solid #ccc';
        autocompleteElement.style.borderRadius = computedStyle.borderRadius || '4px';
        autocompleteElement.style.fontFamily = computedStyle.fontFamily || 'inherit';
        autocompleteElement.style.color = computedStyle.color || 'inherit';
        
        // Replace the input with the autocomplete element
        const container = document.createElement('div');
        container.style.width = '100%';
        container.style.height = '100%';
        container.style.display = 'flex';
        container.style.alignItems = 'center';
        
        input.parentNode.insertBefore(container, input);
        container.appendChild(autocompleteElement);
        input.style.display = 'none';
        
        // Listen for place selection using the new event name
        autocompleteElement.addEventListener('gmp-placeselect', function(event) {
          const place = event.place;
          if (place && place.geometry && place.geometry.location) {
            const lat = typeof place.geometry.location.lat === 'function' 
              ? place.geometry.location.lat() 
              : place.geometry.location.lat;
            const lng = typeof place.geometry.location.lng === 'function' 
              ? place.geometry.location.lng() 
              : place.geometry.location.lng;
            const address = place.formattedAddress || place.name || '';
            
            window.postMessage({
              type: 'places_autocomplete_selected',
              lat: lat,
              lng: lng,
              address: address
            }, '*');
          }
        });
        
        console.log('PlaceAutocompleteElement initialized successfully');
      } catch (error) {
        console.error('Error initializing PlaceAutocompleteElement:', error);
        console.error('Falling back to legacy Autocomplete API');
        // Fallback to old API if new one fails
        _initLegacyAutocomplete(input);
      }
    } else {
      // Fallback to old API if new one is not available
      console.warn('PlaceAutocompleteElement not available, falling back to deprecated Autocomplete');
      console.warn('Please ensure billing is enabled and the latest Google Maps API is loaded');
      _initLegacyAutocomplete(input);
    }
  });
};

// Helper function for legacy Autocomplete (deprecated - only used as fallback)
function _initLegacyAutocomplete(input) {
  try {
    const autocomplete = new google.maps.places.Autocomplete(input, { types: ['geocode'] });
    autocomplete.addListener('place_changed', function() {
      const place = autocomplete.getPlace();
      if (place && place.geometry && place.geometry.location) {
        const lat = place.geometry.location.lat();
        const lng = place.geometry.location.lng();
        const address = place.formatted_address || place.name;
        window.postMessage({
          type: 'places_autocomplete_selected',
          lat: lat,
          lng: lng,
          address: address
        }, '*');
      }
    });
  } catch (error) {
    console.error('Error initializing legacy Autocomplete:', error);
  }
} 