class Artwork < ApplicationRecord
  # 1. Belongs to a User (the artist/creator/owner who uploaded it)
  belongs_to :user
  #    ↑ This assumes you have a User model.
  #    It adds a `user_id` column automatically if you ran:
  #    rails g model Artwork ... user:references
  #    (or you can add it manually later via migration)

  # 2. Has many images using Active Storage (multiple photos per artwork)
  has_many_attached :photos
  #    ↑ Common name: :photos, :images, :pictures — pick one and be consistent.
  #    This lets you do things like:
  #    artwork.photos.attach(io: File.open(...), filename: "front.jpg")
  #    artwork.photos.first    # → first attached image
  #    artwork.photos.any?     # → has images?
  #    In views: <%= image_tag artwork.photos.first if artwork.photos.attached? %>

  # Optional but very useful additions for your app:

  # Validations (prevent saving junk data)
  validates :title, presence: true
  validates :category, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  # validate at least one photo? (custom validation example)
  validate :must_have_at_least_one_photo, if: :new_record?

  private

  def must_have_at_least_one_photo
    errors.add(:photos, "must have at least one photo") unless photos.attached?
  end

  # Optional: default scope (newest first, like in your controller)
  default_scope { order(created_at: :desc) }

  # Optional: scope for published/visible artworks if you add a status later
  # scope :visible, -> { where(status: "published") }
end
