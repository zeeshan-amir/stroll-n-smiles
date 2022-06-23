class GuestReview < Review
  belongs_to :guest, class_name: "User"
  belongs_to :host, class_name: "User"
  belongs_to :room
  belongs_to :reservation
end
