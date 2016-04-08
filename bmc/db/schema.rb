# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 28) do

  create_table "agents", :force => true do |t|
    t.string  "mls_agent_id"
    t.string  "mls_agent_name"
    t.string  "mls_agent_phone"
    t.integer "firm_id"
  end

  create_table "business_photos", :force => true do |t|
    t.integer  "height"
    t.integer  "width"
    t.integer  "size"
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "business_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "businesses", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.integer  "zipcode"
    t.string   "state"
    t.string   "country"
    t.integer  "category_id"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "phone"
    t.string   "url"
    t.string   "fax"
    t.string   "email"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.string   "icon"
  end

  create_table "condos", :force => true do |t|
    t.string  "name"
    t.integer "year_built"
    t.string  "street_number"
    t.string  "street_name"
    t.string  "city"
    t.string  "state"
    t.string  "zip_code"
    t.string  "feature_codes"
    t.string  "latitude",        :limit => 20
    t.string  "longitude",       :limit => 20
    t.string  "main_image"
    t.string  "permalink_condo"
    t.string  "beds"
    t.string  "baths"
    t.integer "no_of_floors"
    t.integer "no_of_units"
    t.integer "featured_weight"
    t.text    "description"
    t.boolean "flash"
  end

  create_table "firms", :force => true do |t|
    t.string "mls_office_id"
    t.string "tln_firm_id"
    t.string "mls_office_name"
    t.string "mls_office_phone"
  end

  create_table "leads", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unit_id"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "business_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photo_galleries", :force => true do |t|
    t.integer "unit_id"
    t.integer "photo_gallery_type_id"
  end

  add_index "photo_galleries", ["unit_id"], :name => "fk_bk_units"
  add_index "photo_galleries", ["photo_gallery_type_id"], :name => "photo_gallery_type_id"

  create_table "photo_gallery_types", :force => true do |t|
    t.string "gallery_type", :limit => 100
  end

  create_table "photos", :force => true do |t|
    t.integer "photo_gallery_id"
    t.string  "image_link"
    t.string  "name"
    t.string  "description"
    t.integer "width"
    t.integer "height"
    t.integer "position"
  end

  add_index "photos", ["photo_gallery_id"], :name => "fk_books_photo_galleries"

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :primary_key => "role_id", :force => true do |t|
    t.integer "user_id", :default => 0, :null => false
  end

  create_table "unit_feature_codes", :force => true do |t|
    t.string "feature_type"
    t.string "feature_code"
    t.string "feature_description"
  end

  create_table "units", :force => true do |t|
    t.string   "mls_listing_id"
    t.integer  "unit_number"
    t.integer  "price"
    t.integer  "bedrooms",        :limit => 255
    t.integer  "bathrooms",       :limit => 255
    t.text     "feature_codes"
    t.string   "sale_or_rent"
    t.text     "description"
    t.integer  "square_footage"
    t.string   "taxes"
    t.string   "tax_year"
    t.integer  "condo_id"
    t.integer  "agent_id"
    t.integer  "firm_id"
    t.string   "permalink_unit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
    t.text     "mls_photos"
    t.integer  "featured_weight"
  end

  add_index "units", ["condo_id"], :name => "condo_id"
  add_index "units", ["firm_id"], :name => "firm_id"
  add_index "units", ["agent_id"], :name => "agent_id"

  create_table "users", :force => true do |t|
    t.string   "username",        :limit => 64,  :default => "",   :null => false
    t.string   "email",           :limit => 128, :default => "",   :null => false
    t.string   "hashed_password", :limit => 64
    t.boolean  "enabled",                        :default => true, :null => false
    t.text     "profile"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_login_at"
    t.string   "first_name",      :limit => 128
    t.string   "last_name",       :limit => 128
    t.string   "phone",           :limit => 128
  end

  add_index "users", ["username"], :name => "index_users_on_username"

end
