class FavoritePosition < ActiveRecord::Base
  after_commit :regenerate_cache

  belongs_to :user
  belongs_to :position

  private
    def regenerate_cache
      Rails.cache.delete("favorites_for_#{self.user_id}_#{I18n.locale}")
    end
end
