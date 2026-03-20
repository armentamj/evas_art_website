class Artwork < ApplicationRecord
  belongs_to :user
  #    ↑ This assumes you have a User model.
  #    It adds a `user_id` column automatically if you ran:
  #    rails g model Artwork ... user:references
  #    (or you can add it manually later via migration)

  # 2. Has many images using Active Storage (multiple images per artwork)
  has_many_attached :images

  # Validations (prevent saving junk data)
  validates :images, attached: true, content_type: [ "image/png", "image/jpeg", "image/webp" ], size: { less_than: 5.megabytes }, limit: { min: 1, max: 5 }
  # validate at least one image?
  validate :must_have_at_least_one_image, if: :new_record?
  validates :title, presence: true
  validates :category, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  CATEGORIES = [
  "Abstract Paintings",
  "Flowers and Still Lifes",
  "Tiny Art"
  ].freeze

  private

  def must_have_at_least_one_image
    errors.add(:images, "Please attach at least one image.") unless images.attached?
  end

  # default scope (newest first, like in the controller)
  default_scope { order(created_at: :desc) }
end
