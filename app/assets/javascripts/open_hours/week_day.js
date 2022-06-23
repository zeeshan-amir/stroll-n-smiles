class OpenHoursWeekDay {
  constructor() {
    this.main   = $("[data-behavior='open-hours-week']");
    this.url    = this.main.data("url");
    this.roomId = this.main.data("room-id");

    if(this.main) {
      // inputs
      this.timeInputs = "[data-behavior^='open-hours-time']";
      this.timeFrom   = "[data-behavior='open-hours-time-open']";
      this.timeTo     = "[data-behavior='open-hours-time-close']";

      // containers
      this.day        = "[data-behavior='open-hours-day']";
      this.blocks     = "[data-behavior='open-hours-blocks']";
      this.block      = "[data-behavior='open-hours-block']";

      // actions
      this.add        = "[data-behavior='open-hours-add']";
      this.delete     = "[data-behavior='open-hours-delete']";

      // contents
      this.closed     = "[data-behavior='open-hours-closed']";
      this.result     = "[data-behavior='open-hours-result']";

      // events
      this.initSelectInputs();
      this.initAddBlockEvent();
      this.initUpdateTimeEvents();
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
  }

  initAddBlockEvent() {
    this.main.on("click", this.add, function(event) {
      let blocks = $(event.target).closest(this.day).find(this.blocks);

      blocks.find(this.closed).closest(this.block).remove();
      blocks.append(openHoursBlock);
    }.bind(this));
  }

  initUpdateTimeEvents() {

    this.main.on("change", this.timeInputs, function(event) {
      let block = $(event.target).closest(this.block)
      let from  = block.find(this.timeFrom).val();
      let to    = block.find(this.timeTo).val();

      if(from.length > 0 && to.length > 0) {
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

  updateOpenHours(block) {
    let blocks = block.closest(this.blocks);
    let url    = this.url;
    let type   = "POST" ;

    if(block.data("id")) {
      type = "PATCH";
      url += "/" + block.data("id");
    }

    block.find(this.result).remove();

    $.ajax({
      type: type,
      url: url,
      data: {
        week_day: blocks.data("day"),
        open: block.find(this.timeFrom).val(),
        close: block.find(this.timeTo).val(),
        room_id: this.roomId,
      },
      success: function(data) {
        block.attr("data-id", data.id);
        block.append(successIcon);
        block.find(this.result).delay(1000).fadeOut(350);

        this.showCompleteCheck();
        if(data.room_ready) this.enablePublishButton();
      }.bind(this),
      error: function(error) {
        block.append(errorIcon);
        toastr.error(error.responseJSON.message);
      }.bind(this),
    });
  }

  deleteOpenHours(block) {
    $.ajax({
      type: "DELETE",
      url: this.url + "/" + block.data("id"),
      success: function(room) {
        if(!room.ready) this.disablePublishButton();
        if(!room.open_hours) this.hideCompleteCheck();

        this.removeBlock(block);
      }.bind(this),
      error: function() {
        toastr.error("Something went wrong, please try again.");
      }
    });
  }

  removeBlock(block) {
    let blocks = block.closest(this.blocks);
    let self   = this;

    block.find(this.delete).css("visibility", "hidden");
    block.find(this.result).remove();
    block.append(successIcon).delay(350).fadeOut(350, function() {
      $(this).remove();

      if(blocks.find(self.block).length < 1) {
        blocks.html(closedBlock);
        blocks.find(self.closed).addClass("open-hours-block__closed--left");
      }
    });
  }

  showCompleteCheck() {
    $("#open_hours_check").show();
  }

  hideCompleteCheck() {
    $("#open_hours_check").hide();
  }

  enablePublishButton() {
    $("#publish_button").attr("disabled", false);
    $("#not-ready-text").hide();
  }

  disablePublishButton() {
    $("#publish_button").attr("disabled", true).val("Publish");
    $("#not-ready-text").show();
  }
}

$(document).ready(function() {
  new OpenHoursWeekDay();
});
