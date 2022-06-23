require "test_helper"

# rubocop:disable Layout/LineLength
class RoomTest < ActiveSupport::TestCase
  should belong_to(:user)
  should have_many(:photos).dependent(:destroy)
  should have_many(:reservations).dependent(:destroy)
  should have_many(:guest_reviews).dependent(:destroy)
  should have_many(:calendars).dependent(:destroy)
  should have_many(:open_hours_week_days).class_name("OpenHours::WeekDay").dependent(:destroy)
  should have_many(:open_hours_special_days).class_name("OpenHours::SpecialDay").dependent(:destroy)

  should validate_presence_of(:name)
  should validate_presence_of(:address)
  should validate_presence_of(:summary)
  should validate_presence_of(:open_hours)
  should validate_numericality_of(:price).is_greater_than_or_equal_to(0)
  should validate_numericality_of(:practitioners).is_greater_than(0)
  should validate_numericality_of(:stations).is_greater_than(0)

  should "reject invalid payment methods" do
    room = rooms(:garbage_compactor)

    room.payment_methods = ["galactic credits"]

    assert_not room.valid?
    assert_equal 1, room.errors[:payment_methods].size
  end

  should "accept valid payment methods" do
    room = rooms(:garbage_compactor)

    room.payment_methods << ["galactic credits"]

    assert_difference "room.errors[:payment_methods].size" do
      assert_not room.valid?
    end
  end

  should "accept valid payment methods" do
    room = rooms(:garbage_compactor)

    assert_no_difference "room.errors[:payment_methods].size" do
      assert room.valid?
    end
  end

  should "geocode when address changes" do
    coordinates = { "latitude" => -0.167369, "longitude" => -78.464880 }
    Geocoder.configure(lookup: :test)
    Geocoder::Lookup::Test.set_default_stub([coordinates])
    room = rooms(:garbage_compactor)
    room.address = "Starkiller Base"

    room.valid?

    assert_equal coordinates["latitude"], room.latitude
    assert_equal coordinates["longitude"], room.longitude
  end

  should "not geocode when address does not change" do
    room = rooms(:garbage_compactor)

    assert_nil room.latitude
    assert_nil room.longitude
  end

  should "deactivate if not approved" do
    room = rooms(:garbage_compactor)
    room.active = true

    room.update(approved: false)

    assert_not room.active?
  end

  should "find active rooms" do
    expected_sql = Room.where(active: true).to_sql

    assert_equal expected_sql, Room.active.to_sql
  end

  should "order rooms by search priority" do
    expected_sql = Room.order(search_priority: :ASC).to_sql

    assert_equal expected_sql, Room.prioritized.to_sql
  end

  should "find and order featured rooms" do
    expected_sql = Room.where(featured: true).
      order(featured_order: :ASC).to_sql

    assert_equal expected_sql, Room.featured.to_sql
  end

  should "find rooms near specified location" do
    expected_rooms = Room.active

    Room.stub(:near, expected_rooms) do
      assert_equal expected_rooms, Room.near_by("Mos Eisley")
    end
  end

  should "find available rooms for specified date" do
    available_rooms = rooms(:garbage_compactor, :first_jedi_temple)

    assert_equal available_rooms, Room.available_on("2020-01-01")
    assert_equal [available_rooms.first], Room.available_on("2015-12-17")
  end

  should "find specified number of active near rooms" do
    expected_rooms = Room.active
    room = rooms(:garbage_compactor)

    room.stub(:nearbys, expected_rooms) do
      assert_equal expected_rooms.active, room.active_nearbys(10)
    end
  end

  should "have availability for hours not booked in specified date" do
    room = rooms(:garbage_compactor)
    reservation = reservations(:rescue_leia)

    date = reservation.datetime.strftime("%Y-%m-%d")

    available_times = %w[07:00 08:00 10:00 11:00 12:00]

    assert_equal available_times, room.availability_on(date)
  end

  should "not have availability for hours booked in specified date" do
    room = rooms(:garbage_compactor)
    reservation = reservations(:rescue_leia)
    date = reservation.datetime.strftime("%Y-%m-%d")
    time = reservation.datetime.strftime("%H:%M")

    assert_not room.availability_on(date).include?(time)
  end

  should "get correct cover photo" do
    room = rooms(:garbage_compactor)
    photo = Photo.new(room: room)
    filename = "garbage_compactor.jpg"

    photo.image.attach(
      io: File.open(Rails.root.join("test", "fixtures", "files", "garbage_compactor.jpg")),
      filename: filename,
      content_type: "image/jpg",
    )

    photo.save

    assert_equal filename, room.cover_photo(:big).send(:filename).to_s

    FileUtils.rm_rf(Dir["tmp/storage/*"])
  end

  should "use blank photo as cover photo when no photo is present" do
    room = rooms(:garbage_compactor)

    assert_equal "blank.jpg", room.cover_photo(:middle)
  end

  should "calculate correct average rating" do
    room = rooms(:garbage_compactor)

    assert_equal 3, room.average_rating
  end

  should "have 0 average rating when no guest reviews are present" do
    room = rooms(:garbage_compactor)
    room.guest_reviews = []

    assert_equal 0, room.average_rating
  end

  should "be ready (is approved, has week open hours and at least one photo)" do
    room = Room.new(approved: true)
    room.photos = [Photo.new]
    room.open_hours_week_days = [OpenHours::WeekDay.new]

    assert room.ready?
  end

  should "not be ready if it has not photos" do
    room = Room.new(approved: true)
    room.open_hours_week_days = [OpenHours::WeekDay.new]

    assert_not room.ready?
  end

  should "not be ready if it has no week open hours" do
    room = Room.new(approved: true)
    room.photos = [Photo.new]

    assert_not room.ready?
  end

  should "not be ready if its not approved" do
    room = Room.new(approved: false)
    room.photos = [Photo.new]
    room.open_hours_week_days = [OpenHours::WeekDay.new]

    assert_not room.ready?
  end
end
# rubocop:enable Layout/LineLength
