class Spot < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  has_many   :spot_histories, dependent: :destroy
  has_many   :users, through: :spot_histories
  has_many   :rules, dependent: :destroy
  has_many   :reviews, dependent: :destroy
  has_many   :images, dependent: :destroy

  belongs_to :category
  belongs_to :allowed_area
  belongs_to :prefecture

  with_options presence: true do
    validates :name, uniqueness: true
    validates :latitude, uniqueness: { scope: :longitude }
    validates :longitude
    validates :address, uniqueness: true
  end

  validates :official_site, format: {
    with:    /\A#{URI::regexp(%w(http https))}\z/,
    message: "URLは「http:」もしくは「https:」から始めてください"
  }
end
