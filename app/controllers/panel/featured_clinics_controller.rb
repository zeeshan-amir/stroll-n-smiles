class Panel::FeaturedClinicsController < PanelController
  def index
    @rooms = Room.featured
  end
end
