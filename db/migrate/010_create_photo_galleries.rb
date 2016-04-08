class CreatePhotoGalleries < ActiveRecord::Migration
  def self.up
    create_table :photo_galleries do |t|    	
      t.column :unit_id, :integer
      t.column :photo_gallery_type_id, :integer
    end
    
    create_table :photos do |t|    	
      t.column :photo_gallery_id, :integer
      t.column :file_name, :integer
      t.column :description, :string, :limit=>255
    end
    
    create_table :photo_gallery_types do |t|    	
    	t.column :type, :string, :limit=>100
  	end
  	
  	say_with_time 'Adding foreign keys' do	
      # Add foreign key reference to photo_galleries tables
      execute 'ALTER TABLE photo_galleries ADD CONSTRAINT fk_bk_units FOREIGN KEY ( unit_id ) REFERENCES units( id ) ON DELETE CASCADE'      
      # Add foreign key reference to photos table
      execute 'ALTER TABLE photos ADD CONSTRAINT fk_books_photo_galleries FOREIGN KEY ( photo_gallery_id ) REFERENCES photo_galleries( id ) ON DELETE CASCADE'
    end
     
  end

  def self.down
    drop_table :photo_galleries
    drop_table :photos
    drop_table :photo_gallery_types
  end
  
end
