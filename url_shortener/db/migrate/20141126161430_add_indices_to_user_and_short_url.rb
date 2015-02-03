class AddIndicesToUserAndShortUrl < ActiveRecord::Migration
  def change
    add_index(:shortened_urls, :short_url, unique: true)
    add_index(:shortened_urls, :user_id)
  end
end
