class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  has_many :positions
  has_many :attachments
  has_many :templates

  belongs_to :currency

  has_many :correspondence_users
  has_many :correspondences, through: :correspondence_users


  validates :fullname, presence: true
  validates :phones, presence: true

  
end
