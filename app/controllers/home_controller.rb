class HomeController < ApplicationController
  def index
    # Base scope – newest first (change :desc to :asc if you prefer oldest first)
    base = Artwork.order(created_at: :desc)

    @tiny_art_first = base.where(category: "Tiny Art").first
    @flowers_and_still_lifes_first = base.where(category: "Flowers and Still Lifes").first
    @abstract_paintings_first = base.where(category: "Abstract Paintings").first
  end
end
