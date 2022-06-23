module PanelHelper
  def status_icon_for(flag)
    icon = flag ? "check" : "times"

    content_tag(:i, "", class: "fa fa-#{icon}-circle-o on")
  end

  def human_boolean(flag)
    flag ? "Yes" : "No"
  end
end
