class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  has_many :documents, dependent: :destroy
  has_many :requisitions
  enum :role, { clerk: 0, approver: 1, admin: 2 }
end
