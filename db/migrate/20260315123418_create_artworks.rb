class CreateArtworks < ActiveRecord::Migration[8.0]
  def change
    create_table :artworks do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.string :category
      t.string :size

      t.timestamps
    end
  end
end
