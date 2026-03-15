json.extract! artwork, :id, :title, :description, :price, :category, :size, :created_at, :updated_at
json.url artwork_url(artwork, format: :json)
