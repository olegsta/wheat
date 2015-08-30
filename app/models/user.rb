class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  after_commit :regenerate_cache

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  has_many :positions
  has_many :attachments
  has_many :templates

  belongs_to :currency

  has_many :correspondence_users
  has_many :correspondences, through: :correspondence_users

  has_many :favorite_positions
  has_many :favorites, through: :favorite_positions, source: :position


  validates :fullname, presence: true
  validates :phones, presence: true

  def info_from_cache
    Rails.cache.fetch("user_info_#{self.id}_#{I18n.locale}") do
      UserSerializer.new(self, root: false).as_json
    end
  end

  def favorites_from_cache
    Rails.cache.fetch("favorites_for_#{self.id}_#{I18n.locale}") do
      ActiveModel::ArraySerializer.new(self.favorites.full, serializer: PositionSerializer).as_json
    end
  end

  def positions_from_cache status
    Rails.cache.fetch("user_positions_#{self.id}_#{status}_#{I18n.locale}") do
      ActiveModel::ArraySerializer.new(self.positions.where(status: status).full, serializer: PositionWithOffersSerializer).as_json
    end
  end

  private
    def regenerate_cache
      Rails.cache.delete("user_info_#{self.id}_#{I18n.locale}")
    end
end
