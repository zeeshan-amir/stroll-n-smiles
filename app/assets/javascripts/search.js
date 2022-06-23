// Classes
class SingleFieldForm {
  constructor() {
    this.form = $("[data-behavior='single-field-form']");

    if(this.form) {
      this.form.find("input[type=text]").on("keypress", function(event) {
        this.submit(event.which);
      }.bind(this));
    }
  }

  submit(key) {
    if(key == 10 || key == 13) {
      this.form.submit();
    }
  }
}

class AdvancedSearch {
  constructor() {
    this.filterButton = $("[data-behavior='search-filter-button']");
    this.formBox = $("[data-behavior='search-form-box']");
    this.minPrice = $("[data-behavior='search-min-price']");
    this.maxPrice = $("[data-behavior='search-max-price']");
    this.priceSlider = $("[data-behavior='search-price-slider']");

    if(this.filterButton) {
      this.filterButton.on("click", function() {
        this.displayForm();
      }.bind(this));

      this.initSlider();
    }
  }

  displayForm() {
    this.formBox.slideToggle();
    this.filterButton.children("i").toggleClass("fa-chevron-down fa-chevron-up");
  }

  initSlider() {
    let minimum = this.minPrice.data("limit");
    let maximum = this.maxPrice.data("limit");

    this.priceSlider.slider({
      range: true,
      min: minimum,
      max: maximum,
      values: [minimum, maximum],
      slide: function(event, ui) {
        this.minPrice.val(ui.values[0]);
        this.maxPrice.val(ui.values[1]);
      }.bind(this)
    });
  }
}

// Functions
function initializeMap(rooms, address) {
  geocoder = new google.maps.Geocoder();

  geocoder.geocode({ 'address': address }, function(results, status) {
    var latitude = -0.1815;
    var longitude = -78.4817;

    if (rooms.length > 0) {
      latitude = rooms[0].latitude;
      longitude = rooms[0].longitude ;
    } else if(status == google.maps.GeocoderStatus.OK) {
      latitude = results[0].geometry.location.lat();
      longitude = results[0].geometry.location.lng();
    }

    var map = new google.maps.Map(document.querySelector("[data-behavior='map']"), {
      center: new google.maps.LatLng(latitude, longitude),
      zoom: 12
    });

    var marker, inforwindow;

    rooms.forEach(function(room) {
      marker = new google.maps.Marker({
        position: { lat: room.latitude, lng: room.longitude },
        map: map
      });

      inforwindow = new google.maps.InfoWindow({
        content: "<div class='map_price'>$" + room.price + "</div>"
      });

      inforwindow.open(map, marker);
    });
  });
}

// Initialize
$(function() {
  new SingleFieldForm();
  new AdvancedSearch();

  $("[data-behavior='geocomplete']").geocomplete();
  $("[data-behavior='datepicker']").datepicker({
    dateFormat: 'dd-mm-yy',
    minDate: 0,
    maxDate: '3m'
  });
});
