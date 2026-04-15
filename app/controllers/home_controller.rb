class HomeController < ApplicationController
  allow_unauthenticated_access only: :index
  def index
    # Base scope – newest first (change :desc to :asc if you prefer oldest first)
    base = Artwork.with_attached_images.order(created_at: :desc)

    @tiny_art_first = base.where(category: "Tiny Art").first
    @flowers_and_still_lifes_first = base.where(category: "Flowers and Still Lifes").first
    @abstract_paintings_first = base.where(category: "Abstract Paintings").first

    # For hero image preloading
    if @abstract_paintings_first&.images&.attached?
      # Defines the variant settings here so they match the view exactly
      variant_settings = {
        resize_to_limit: [ 800, 800 ],
        format: :webp,
        saver: { quality: 80, strip: true }
      }

      # This generates the specific URL for the browser to preload
      @hero_image_url = url_for(@abstract_paintings_first.images.first.variant(variant_settings))
    end
  end
end
