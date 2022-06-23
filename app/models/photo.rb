class Photo < ApplicationRecord
  DEFAULT_SIZES = {
    medium: "351x239",
    thumb: "100x68",
    big: "1200x400",
  }.freeze

  belongs_to :room

  has_one_attached :image

  validates :image,
            attached: true,
            content_type: ["image/png", "image/jpg", "image/jpeg"]

  after_destroy :update_room_active_status

  def fitted(size)
    image.variant(
      combine_options: {
        resize: DEFAULT_SIZES[size].split("x").first,
        gravity: "Center",
        crop: "#{DEFAULT_SIZES[size]}+0+0",
        auto_orient: true,
      },
    )
  end

  private

  def update_room_active_status
    room.update_active_status
  end
end
