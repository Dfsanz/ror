class CreateBusinessPhotos < ActiveRecord::Migration
  def self.up
    create_table :business_photos do |t|
      t.integer :height
      t.integer :width
      t.integer :size
      t.integer :parent_id
      t.string :content_type
      t.string :filename
      t.string :thumbnail
      t.references :business

      t.timestamps
    end
  end

  def self.down
    drop_table :business_photos
  end
end
