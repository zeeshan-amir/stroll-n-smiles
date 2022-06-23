module ApplicationHelper
  def avatar_url(user)
    if user.image
      "https://graph.facebook.com/#{user.uid}/picture?type=large"
    else
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      default     = ERB::Util.url_encode(image_url("logo.png"))

      "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=#{default}&s=150"
    end
  end

  def dashboard_menu_link(description, path)
    klass = "active" if current_page?(path)

    content_tag(:li, link_to(description, path), class: klass)
  end
end
