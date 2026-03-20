class AddUserToArtworks < ActiveRecord::Migration[8.0]
  def change
    add_reference :artworks, :user, null: false, foreign_key: true
  end
end
