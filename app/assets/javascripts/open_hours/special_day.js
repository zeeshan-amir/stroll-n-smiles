class OpenHoursSpecialDay {
  constructor() {
    this.main   = $("[data-behavior='open-hours-special']");
    this.url    = this.main.data("url");
    this.roomId = this.main.data("room-id");

    if(this.main) {
      // inputs
      this.timeInputs = "[data-behavior^='open-hours-time']";
      this.dateInputs = "[data-behavior^='open-hours-date']";
      this.timeFrom   = "[data-behavior='open-hours-time-open']";
      this.timeTo     = "[data-behavior='open-hours-time-close']";
      this.dateDay    = "[data-behavior='open-hours-date-day']";
      this.dateMonth  = "[data-behavior='open-hours-date-month']";

      // containers
      this.days       = "[data-behavior='open-hours-days']";
      this.day        = "[data-behavior='open-hours-day']";
      this.blocks     = "[data-behavior='open-hours-blocks']";
      this.block      = "[data-behavior='open-hours-block']";

      // actions
      this.new        = "[data-behavior='open-hours-new']";
      this.add        = "[data-behavior='open-hours-add']";
      this.delete     = "[data-behavior='open-hours-delete']";

      // contents
      this.closed     = "[data-behavior='open-hours-closed']";
      this.result     = "[data-behavior='open-hours-result']";

      // events
      this.initSelectInputs();
      this.initNewDayEvent();
      this.initAddBlockEvent();
      this.initChangeTimeEvents();
      this.initChangeDateEvents();
      this.initDeleteEvent();
    }
  }

  initSelectInputs() {
    this.main.find(this.timeFrom).append(function() {
      return timeSelectOptions("open", $(this).data("value"));
    });

    this.main.find(this.timeTo).append(function() {
      return timeSelectOptions("close", $(this).data("value"));
    });

    this.main.find(this.dateDay).append(function() {
      return daySelectOptions($(this).data("value"));
    });

    this.main.find(this.dateMonth).append(function() {
      return monthSelectOptions($(this).data("value"));
    });
  }


  initNewDayEvent() {
    this.main.on("click", this.new, function() {
      let days = this.main.find(this.days);
      let day  = openHoursDay();

      day.find(this.closed).addClass("open-hours-block__closed--js-fix-right");
      days.append(day);
    }.bind(this));
  }

  initAddBlockEvent() {
    this.main.on("click", this.add, function(event) {
      let blocks = $(event.target).closest(this.day).find(this.blocks);
      let closed = blocks.find(this.closed);

      if(closed.length > 0) {
        closed.closest(this.block).html("")
          .append(fromSelect)
          .append(toSelect)
          .append(deleteIcon);
      } else {
        blocks.append(openHoursBlock);
      }
    }.bind(this));
  }

  initChangeDateEvents() {
    this.main.on("change", this.dateInputs, function(event) {
      let day       = $(event.target).closest(this.day);
      let dateDay   = day.find(this.dateDay).val();
      let dateMonth = day.find(this.dateMonth).val();

      if(dateDay > 0 && dateMonth > 0) {
        let blocks = day.find(this.block);
        let self   = this;

        blocks.each(function() {
          let block    = $(this);
          let closed   = block.find(this.closed);
          let timeFrom = block.find(self.timeFrom).val();
          let timeTo   = block.find(self.timeTo).val();

          if(closed || timeFrom.length > 0 && timeTo.length > 0) {
            self.updateOpenHours(block);
          }
        });
      }
    }.bind(this));
  }

  initChangeTimeEvents() {
    this.main.on("change", this.timeInputs, function(event) {
      let day       = $(event.target).closest(this.day);
      let block     = $(event.target).closest(this.block);
      let dateDay   = day.find(this.dateDay).val();
      let dateMonth = day.find(this.dateMonth).val();
      let timeFrom  = block.find(this.timeFrom).val();
      let timeTo    = block.find(this.timeTo).val();

      if(dateDay > 0 && dateMonth > 0 && timeFrom.length > 0 && timeTo.length > 0) {
        this.updateOpenHours(block);
      }
    }.bind(this));
  }

  initDeleteEvent() {
    this.main.on("click", this.delete, function(event) {
      let block = $(event.target).closest(this.block);

      if(block.data("id")) {
        this.deleteOpenHours(block);
      } else {
        this.removeBlock(block);
      }
    }.bind(this));
  }

  deleteOpenHours(block) {
    $.ajax({
      type: "DELETE",
      url: this.url + "/" + block.data("id"),
      success: function() {
        this.removeBlock(block);
      }.bind(this),
      error: function() {
        toastr.error("Something went wrong, please try again.");
      }
    });
  }

  removeBlock(block) {
    let blocks  = block.closest(this.blocks).find(this.block);

    block.find(this.delete).css("visibility", "hidden");
    block.find(this.result).remove();
    block.append(successIcon);

    if(blocks.length == 1) {
      block = block.closest(this.day);
    }

    block.delay(350).fadeOut(350, function() {
      $(this).remove();
    });
  }

  updateOpenHours(block) {
    let day  = block.closest(this.day);
    let url  = this.url;
    let type = "POST" ;

    if(block.data("id")) {
      type = "PATCH";
      url += "/" + block.data("id");
    }

    block.find(this.result).remove();

    $.ajax({
      type: type,
      url: url,
      data: {
        day: day.find(this.dateDay).val(),
        month: day.find(this.dateMonth).val(),
        open: block.find(this.timeFrom).val(),
        close: block.find(this.timeTo).val(),
        room_id: this.roomId,
      },
      success: function(data) {
        block.attr("data-id", data.id);
        block.append(successIcon);
        block.find(this.result).delay(1000).fadeOut(350);
      }.bind(this),
      error: function(error) {
        block.append(errorIcon);
        toastr.error(error.responseJSON.message);
      }.bind(this),
    });
  }
}

$(document).ready(function() {
  new OpenHoursSpecialDay();
});
