class Visit < ActiveRecord::Base

  belongs_to :visitor,
    class_name: "User",
    foreign_key: :visitor_id,
    primary_key: :id

  belongs_to :visited_url,
    class_name: "ShortenedUrl",
    foreign_key: :url_id,
    primary_key: :id

  def self.record_visit!(user, shortened_url)
    Visit.create!(visitor: user, visited_url: shortened_url)
  end

end
