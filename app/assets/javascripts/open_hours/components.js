function deleteIcon() {
  return $("<i></i>", {
    "class": "fa fa-trash open-hours-block__delete",
    "aria-hidden": "true",
    "data-behavior": "open-hours-delete",
  });
}

function successIcon() {
  return $("<i></i>", {
    "class": "fa fa-check text-success open-hours-block__result",
    "data-behavior": "open-hours-result",
    "aria-hidden": "true",
  });
}

function errorIcon() {
  return $("<i></i>", {
    "class": "fa fa-times text-danger open-hours-block__result",
    "data-behavior": "open-hours-result",
    "aria-hidden": "true",
  });
}

function addLabel() {
  return $("<span></span>", {
    "class": "open-hours__link",
    "data-behavior": "open-hours-add",
  }).text("add")
}

function closedLabel() {
  return $("<span></span>", {
    "class": "open-hours-block__closed",
    "data-behavior": "open-hours-closed",
  }).text("Closed");
}

function closedBlock() {
  return $("<div></div>", {
    "class": "open-hours-block",
    "data-behavior": "open-hours-block",
  }).append(closedLabel);
}

function fromSelect() {
  return $("<select></select>", {
    "class": "open-hours__select open-hours__select--js-fix-left",
    "data-behavior": "open-hours-time-open",
  }).append(timeSelectOptions("open"));
}

function toSelect() {
  return $("<select></select>", {
    "class": "open-hours__select open-hours__select--js-fix-right",
    "data-behavior": "open-hours-time-close",
  }).append(timeSelectOptions("close"));
}

function daySelect() {
  return $("<select></select>", {
    "class": "open-hours__select",
    "data-behavior": "open-hours-date-day",
  }).append(daySelectOptions());
}

function monthSelect() {
  return $("<select></select>", {
    "class": "open-hours__select open-hours__select--js-fix-left",
    "data-behavior": "open-hours-date-month",
  }).append(monthSelectOptions());
}

function openHoursBlock() {
  return $("<div></div>", {
    "class": "open-hours-block",
    "data-behavior": "open-hours-block",
  }).append(fromSelect)
    .append(toSelect)
    .append(deleteIcon);
}

function openHoursDay() {
  return $("<tr></tr>", {
    "data-behavior": "open-hours-day",
  }).append($("<td></td>")
    .append($("<div></div>", {
      "class": "open-hours-day",
    }).append(monthSelect).append(daySelect)))
      .append($("<td></td>").append(addLabel))
      .append($("<td></td>", {
      "data-behavior": "open-hours-blocks",
    }).append(closedBlock().append(deleteIcon)));
}

// select options
function timeSelectOptions(label, value) {
  const START = 8;
  const END   = 22;

  let options = "<option value=''>" + label + "</option>";

  for(let i = START; i <= END; i++) {
    let hours = i > 9 ? i : "0" + i;

    ["00", "30"].forEach(function(minutes) {
      let time     = hours + ":" + minutes;
      let selected = value == time ? " selected" : "";

      if(minutes == "00" || i < END) {
        options += "<option value='" + time + "'" + selected + ">" + time + "</option>";
      }
    });
  }

  return options;
}

function daySelectOptions(value) {
  let options = "<option>day</option>";

  for(let i = 1; i <= 31; i++) {
    let selected = parseInt(value) == i ? " selected" : "";

    options += "<option value='" + i + "'" + selected + ">" + i + "</option>";
  }

  return options;
}

function monthSelectOptions(value) {
  let months  = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dic'];
  let options = "<option>month</option>";

  months.forEach(function(month, i) {
    let selected = value == (i + 1) ? " selected" : "";

    options += "<option value='" + (i + 1) + "'" + selected + ">" + month + "</option>";
  });

  return options;
}
