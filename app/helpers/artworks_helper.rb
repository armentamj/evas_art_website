module ArtworksHelper
  def to_snake_case(str)
    str.downcase.gsub(" ", "_")
  end
end
