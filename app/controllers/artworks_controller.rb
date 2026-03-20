class ArtworksController < ApplicationController
  before_action :require_authentication, only: [ :new, :create, :edit, :update, :destroy ]

  allow_unauthenticated_access only: %i[index show]

  before_action :set_artwork, only: [ :show, :edit, :update, :destroy ]

  # GET /artworks or /artworks?category=...
  def index
    @artworks = Artwork.order(created_at: :desc)

    # Check for either :slug (from your category_path) or :category params
    if (category_slug = params[:slug] || params[:category]).present?
      # 1. Replace hyphens with spaces: "abstract-paintings" -> "abstract paintings"
      # 2. Titleize: "abstract paintings" -> "Abstract Paintings"
      category_name = category_slug.gsub("-", " ").titleize.strip

      # Use a case-insensitive search to be extra safe
      @artworks = @artworks.where("LOWER(category) = ?", category_name.downcase)
      @current_category = category_name
    end

    # Handling the ID lookup/redirect
    if params[:id].present?
      artwork = Artwork.find_by(id: params[:id])
      if artwork
        redirect_to artwork_path(artwork) and return
      else
        flash.now[:alert] = "No artwork found with ID #{params[:id]}"
      end
    end
  end

  # GET /artworks/1
  def show
  end

  # GET /artworks/new
  def new
    @artwork = Artwork.new
  end

  # GET /artworks/1/edit
  def edit
  end

  # POST /artworks
  def create
    @artwork = Artwork.new(artwork_params)

    # Add this line to assign the logged-in user
    @artwork.user = Current.user

    if @artwork.save
      redirect_to @artwork, notice: "Artwork was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end


  # PATCH/PUT /artworks/1
  def update
    if @artwork.update(artwork_params)
      redirect_to @artwork, notice: "Artwork was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /artworks/1
  def destroy
    @artwork.destroy!
    redirect_to artworks_path, notice: "Artwork was successfully destroyed.", status: :see_other
  end

  private

    def set_artwork
      @artwork = Artwork.find(params.expect(:id))
    end

    def artwork_params
      params.expect(artwork: [
        :title,
        :description,
        :price,
        :category,
        :size,
        images: []
      ])
    end
end
