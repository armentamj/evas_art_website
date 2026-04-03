class ArtworksController < ApplicationController
  before_action :require_authentication, only: [ :new, :create, :edit, :update, :destroy ]

  allow_unauthenticated_access only: %i[index show]

  before_action :set_artwork, only: [ :show, :edit, :update, :destroy ]

  # GET /artworks or /artworks?category=...
  def index
    @artworks = Artwork.order(created_at: :desc)

    # Check for either :slug (from your category_path) or :category params
    if (category_slug = params[:slug] || params[:category]).present?
      category_name = category_slug.gsub("-", " ").titleize.strip
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
    set_meta_tags(
      title: @artwork.title,
      description: @artwork.description.to_s.truncate(160),
      og: {
        title: @artwork.title,
        type: "website",
        url: artwork_url(@artwork),
        image: @artwork.images.attached? ? url_for(@artwork.images.first) : nil
      }
    )
  end

  # GET /artworks/new
  def new
    @artwork = Artwork.new
    set_meta_tags noindex: true
  end

  # GET /artworks/1/edit
  def edit
    set_meta_tags noindex: true
  end

  # POST /artworks
  def create
    @artwork = Artwork.new(artwork_params)
    @artwork.user = Current.user

    if @artwork.save
      redirect_to @artwork, notice: "Artwork was successfully created."
    else
      set_meta_tags noindex: true
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /artworks/1
  def update
    if @artwork.update(artwork_params)
      redirect_to @artwork, notice: "Artwork was successfully updated.", status: :see_other
    else
      set_meta_tags noindex: true
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /artworks/1
  def destroy
    @artwork.destroy!
    redirect_to artworks_path, notice: "Artwork was successfully destroyed.", status: :see_other
  end

  # Action for the Red X button (Taking away a specific image)
  def delete_image
    @image = ActiveStorage::Attachment.find(params[:image_id])
    @image.purge

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(helpers.dom_id(@image)) }
      format.html { redirect_back fallback_location: edit_artwork_path(@image.record) }
    end
  end

  private

    def set_artwork
      @artwork = Artwork.friendly.find(params.expect(:id))
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
