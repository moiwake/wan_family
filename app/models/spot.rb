class Spot < ApplicationRecord
  has_many :spot_histories, dependent: :destroy
  has_many :users, through: :spot_histories
  has_many :rules, dependent: :destroy, autosave: true
  has_many :reviews, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :spot_favorites, dependent: :destroy
  has_many :spot_tags, dependent: :destroy

  with_options presence: true do
    validates :name, uniqueness: true
    validates :latitude, uniqueness: { scope: :longitude }
    validates :longitude
    validates :address, uniqueness: true
  end

  belongs_to :category
  belongs_to :allowed_area
  belongs_to :prefecture

  validates :official_site, format: {
    with: /\A#{URI.regexp(%w(http https))}\z/,
    message: "URLは「http:」もしくは「https:」から始めてください",
  }, allow_blank: true

  is_impressionable counter_cache: true

  def self.ransackable_attributes(auth_object = nil)
    ["address", "allowed_area_id", "category_id", "id", "latitude", "longitude", "name", "prefecture_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["allowed_area", "category", "prefecture"]
  end
end
