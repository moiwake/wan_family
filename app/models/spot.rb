class Spot < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  has_many   :spot_histories, dependent: :destroy
  has_many   :users, through: :spot_histories
  belongs_to :category
  belongs_to :allowed_area
  has_many   :rule, dependent: :destroy
  has_many   :reviews, dependent: :destroy
  has_many   :images, dependent: :destroy
  belongs_to :prefecture

  with_options presence: true do
    validates :name, uniqueness: true
    validates :latitude, uniqueness: { scope: :longitude }
    validates :longitude
    validates :address, uniqueness: true
  end

  scope :"includes_images", -> { includes(images: { files_attachments: :blob }) }
end
