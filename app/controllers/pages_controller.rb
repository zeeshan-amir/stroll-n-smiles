class PagesController < ApplicationController
  def home
    @rooms = Room.active.featured.limit(6)
  end

  def why; end

  def how_it_works; end

  def faq; end

  def about; end

  def privacy; end

  def terms; end

  def search
    @search = RoomSearch.new(
      location: params[:location].presence,
      date: params[:date].presence,
      filters: params[:q].presence,
    )
  end
end
