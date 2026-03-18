class ArtworksController < ApplicationController
  before_action :require_authentication, only: [ :new, :create, :edit, :update, :destroy ]

  allow_unauthenticated_access only: %i[index show]

  before_action :set_artwork, only: [ :show, :edit, :update, :destroy ]
  # GET /artworks or /artworks.json
  def index
    @artworks = Artwork.order(created_at: :desc)  # or your preferred order

    if params[:slug].present? || params[:category].present?
      # Handle both friendly slug and query param style
      category_slug = params[:slug] || params[:category]
      category_name = category_slug.to_s.titleize.gsub("-", " ")

      @artworks = @artworks.where(category: category_name)
      @current_category = category_name   # for display in view
    end

    # Optional: add pagination later
    # @artworks = @artworks.page(params[:page]).per(12)
  end

  # GET /artworks/1 or /artworks/1.json
  def show
  end

  # GET /artworks/new
  def new
    @artwork = Artwork.new
  end

  # GET /artworks/1/edit
  def edit
  end

  # POST /artworks or /artworks.json
  def create
    @artwork = Artwork.new(artwork_params)

    respond_to do |format|
      if @artwork.save
        format.html { redirect_to @artwork, notice: "Artwork was successfully created." }
        format.json { render :show, status: :created, location: @artwork }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @artwork.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /artworks/1 or /artworks/1.json
  def update
    respond_to do |format|
      if @artwork.update(artwork_params)
        format.html { redirect_to @artwork, notice: "Artwork was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @artwork }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @artwork.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /artworks/1 or /artworks/1.json
  def destroy
    @artwork.destroy!

    respond_to do |format|
      format.html { redirect_to artworks_path, notice: "Artwork was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_artwork
      @artwork = Artwork.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def artwork_params
      params.expect(artwork: [ :title, :description, :price, :category, :size ])
    end
end
