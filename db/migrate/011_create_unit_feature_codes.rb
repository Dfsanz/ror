class CreateUnitFeatureCodes < ActiveRecord::Migration
  def self.up
    create_table :unit_feature_codes do |t|
    end
  end

  def self.down
    drop_table :unit_feature_codes
  end
end
