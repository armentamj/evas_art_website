class HomeController < ApplicationController
  allow_unauthenticated_access only: :index

  def index
    # Fetch all three records in one optimized database query
    categories = [ "Tiny Art", "Flowers and Still Lifes", "Abstract Paintings" ]
    artworks = Artwork.with_attached_images
                      .where(category: categories)
                      .order(created_at: :desc)
                      .to_a # Executes a single query and loads objects into memory

    # Extract the first record for each category from the in-memory array
    @tiny_art_first = artworks.find { |a| a.category == "Tiny Art" }
    @flowers_and_still_lifes_first = artworks.find { |a| a.category == "Flowers and Still Lifes" }
    @abstract_paintings_first = artworks.find { |a| a.category == "Abstract Paintings" }

    # Setup global variant matching parameters
    variant_settings = {
      resize_to_limit: [ 800, 800 ],
      format: :webp,
      saver: { quality: 80, strip: true }
    }

    # Safely generate URLs
    if @abstract_paintings_first&.images&.attached?
      @hero_image_url_one = url_for(@abstract_paintings_first.images.first.variant(variant_settings))
    end

    if @flowers_and_still_lifes_first&.images&.attached?
      @hero_image_url_two = url_for(@flowers_and_still_lifes_first.images.first.variant(variant_settings))
    end

    if @tiny_art_first&.images&.attached?
      @hero_image_url_three = url_for(@tiny_art_first.images.first.variant(variant_settings))
    end
  end
end
