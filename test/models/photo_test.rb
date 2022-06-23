require "test_helper"

# rubocop:disable Layout/LineLength
class PhotoTest < ActiveSupport::TestCase
  should belong_to(:room)

  should validate_attached_of(:image)
  should validate_content_type_of(:image).allowing("image/png", "image/jpg", "image/jpeg")
end
# rubocop:enable Layout/LineLength
