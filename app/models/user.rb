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

  def offers
    self.positions.joins("INNER JOIN positions_offers ON positions_offers.offer_id = positions.id")
  end

  def info_from_cache
    Rails.cache.fetch("user_info_#{self.id}_#{I18n.locale}") do
      UserSerializer.new(self, root: false).as_json
    end
  end

  def self.info_from_cache id
    Rails.cache.fetch("user_info_#{id}_#{I18n.locale}") do
      UserSerializer.new(User.find(id), root: false).as_json
    end
  end

  def favorites_from_cache
    Rails.cache.fetch("favorites_for_#{self.id}_#{I18n.locale}") do
      ActiveModel::ArraySerializer.new(self.favorites.full.load, each_serializer: PositionSerializer).as_json
    end
  end

  def positions_from_cache status
    Rails.cache.fetch("user_positions_#{self.id}_#{status}_#{I18n.locale}") do
      ActiveModel::ArraySerializer.new(self.positions.where(status: status).order('updated_at desc').full.load, each_serializer: PositionWithOffersSerializer).as_json
    end
  end

  def offers_from_cache
    Rails.cache.fetch("user_offers_#{self.id}_#{I18n.locale}") do
      ActiveModel::ArraySerializer.new(self.offers.load.order('updated_at desc').full, each_serializer: OfferWithPositionsSerializer).as_json
    end
  end

  def position_from_cache id
    Rails.cache.fetch("user_position_#{self.id}_#{id}_#{I18n.locale}") do
      self.positions.find(id)
    end
  end

  private
    def regenerate_cache
      Rails.cache.delete("user_info_#{self.id}_#{I18n.locale}")
      self.correspondences.pluck(:id).each do |correspondence_id|
        Rails.cache.delete("correspondence_user_#{correspondence_id}_#{I18n.locale}")
        Rails.cache.delete("correspondence_position_#{correspondence_id}_#{I18n.locale}")
        Rails.cache.delete("correspondence_positions_#{correspondence_id}_#{I18n.locale}")
      end
    end
end
