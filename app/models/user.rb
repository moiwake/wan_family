class User < ApplicationRecord
  has_many :spot_histories, dependent: :destroy
  has_many :spots, through: :spot_histories
  has_many :reviews, dependent: :destroy
  has_many :images, dependent: :destroy

  has_one_attached :avatar

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, uniqueness: true
  validates :avatar, blob: {
    content_type: ['image/png', 'image/jpg', 'image/jpeg'],
    size_range: 1..(5.megabytes),
  }, on: :update

  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze
  validates :password, format: {
    with: PASSWORD_REGEX,
    message: 'は英字と数字の両方を含めて設定してください', if: :password_required?,
    allow_blank: true
  }
end
