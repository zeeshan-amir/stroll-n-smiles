class RoomReservation {
  constructor() {
    this.form      = $("[data-behavior='room-reservation-form']");
    this.available = this.form.data("available");

    if(this.form) {
      this.displayNoAvailability();

      // inputs
      this.date = "[data-behavior='room-reservation-date']";
      this.time = "[data-behavior='room-reservation-time']";

      // events
      this.initDate();
    }
  }

  initDate() {
    this.form.find(this.date).datepicker({
      dateFormat: 'dd-mm-yy',
      minDate: 0,
      maxDate: '3m',
      onSelect: function(date) {
        this.updateAvailableTimes(date);
      }.bind(this),
    });
  }

  updateAvailableTimes(date) {
    $.ajax({
      type: "GET",
      url: this.form.find(this.date).data("url"),
      data: { date: date },
      success: function(times) {
        this.resetTimeOptions(times);
      }.bind(this),
    });
  }

  resetTimeOptions(times) {
    let options = "";

    times.forEach(function(time) {
      options += "<option value='" + time + "'>" + time + "</option>";
    });

    this.form.find("[data-behavior='room-no-availability']").remove();
    this.form.find(this.time).html(options)

    if(options.length == 0) {
      this.displayNoAvailability();
    }
  }

  displayNoAvailability() {
    if(!this.available) {
      this.form.find(":submit").before(this.noAvailability);
    }
  }

  noAvailability() {
    return $("<div></div>", {
      "class": "room__no-availability",
      "data-behavior": "room-no-availability",
    }).html("No availability, please select another date.");
  }
}

$(document).ready(function() {
  new RoomReservation();
});
