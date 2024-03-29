class User < ApplicationRecord
  has_many :spot_histories
  has_many :spots, through: :spot_histories
  has_many :reviews, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :review_helpfulnesses, dependent: :destroy
  has_many :image_likes, dependent: :destroy
  has_many :spot_favorites, dependent: :destroy
  has_many :spot_tags, dependent: :destroy

  has_one_attached :human_avatar
  has_one_attached :dog_avatar

  validates :name, presence: true, uniqueness: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :human_avatar, :dog_avatar, blob: {
    content_type: ['image/png', 'image/jpg', 'image/jpeg'],
    size_range: 1..(5.megabytes),
  }, on: :update

  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i
  validates :password, format: {
    with: PASSWORD_REGEX,
    message: 'は英字と数字の両方を含めて設定してください', if: :password_required?,
    allow_blank: true,
  }

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.hex
      user.name = "ゲストユーザー"
    end
  end
end
