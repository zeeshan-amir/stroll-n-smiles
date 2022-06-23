class RoomSearch
  DEFAULT_LOCATION = "Quito, Ecuador".freeze

  attr_reader :location, :date, :filters

  def initialize(location:, date:, filters: nil)
    @location = location || DEFAULT_LOCATION
    @date = date || Date.today.to_s
    @filters = filters
  end

  def query
    @query ||= Room.active.near_by(location).ransack(filters)
  end

  def rooms
    @rooms ||= query.result.prioritized.available_on(date)
  end

  def maximum_price
    query.result.maximum_price
  end

  def minimum_price
    query.result.minimum_price
  end

  def empty?
    rooms.empty?
  end
end
