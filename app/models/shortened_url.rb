class ShortenedUrl < ActiveRecord::Base
  include SecureRandom

  validates :long_url, presence: true, uniqueness: true, length: {maximum: 1024}
  validates :short_url, presence: true, uniqueness: true

  belongs_to :submitter,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  has_many :visits,
    class_name: "Visit",
    foreign_key: :url_id,
    primary_key: :id

  has_many :visitors, -> { distinct}, through: :visits, source: :visitor
  has_many :tags, through: :taggings, source: :tag
  def self.random_code
    begin
      code = SecureRandom::urlsafe_base64
    end while ShortenedUrl.exists?(short_url: code)
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    user.submitted_urls.create!(long_url: long_url, short_url: random_code)
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    Visit.select(:visitor_id).where(url_id: id).count
  end

  def num_recent_uniques
    Visit.select(:visitor_id).where(url_id: id, created_at: 10.minutes.ago..Time.now).count
  end

end
