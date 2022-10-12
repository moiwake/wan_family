class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :trackable and :omniauthable, :registerable, :recoverable,
  devise :database_authenticatable, :rememberable, :validatable, :timeoutable

  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze
  validates_format_of :password, with: PASSWORD_REGEX,
                                 message: 'は英字と数字の両方を含めて設定してください', if: :password_required?,
                                 allow_blank: true
end
