class CreateTagging < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.integer :tag_id
      t.integer :url_id
      t.timestamps
    end
  end
end
