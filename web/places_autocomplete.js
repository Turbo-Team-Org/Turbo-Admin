// Google Places Autocomplete JS for Flutter Web
window.initPlacesAutocomplete = function(inputId) {
  const input = document.getElementById(inputId);
  if (!input) return;
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
}; 