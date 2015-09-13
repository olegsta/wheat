class PositionsOffer < ActiveRecord::Base
  after_commit :regenerate_cache

  belongs_to :position, touch: true
  belongs_to :offer, :class_name => "Position", touch: true

  validate :trade_type_validate
  validate :user_validate
  validate :status_validate
  validate :option_validate
  validate :price_validate
  validate :weight_validate


  private
    def trade_type_validate
      errors.add(:trade_type_id, "Совпадает тип позиции") if position.trade_type_id == offer.trade_type_id
    end

    def user_validate
      errors.add(:user_id, "Нельзя заключить сделку с собой") if position.user_id == offer.user_id
    end

    def status_validate
      errors.add(:status, "Статус обеих позиции должен быть «Открыто»") if (position.status != 'opened') or (position.status != 'opened')
    end

    def option_validate
      errors.add(:option_id, "Товары в позициях не совпадают") if position.option_id != offer.option_id
    end

    def price_validate
      price_in_currency = position.price_etalon * position.currency.get_rate(offer.currency.name)

      if position.trade_type_id == 1
        price_in_currency *= 1 + position.price_discount/100.0
        errors.add(:price, "Цена предожения слишком большая") unless offer.price_etalon.between?(0.0, price_in_currency)
      elsif position.trade_type_id == 2
        price_in_currency *= 1 - position.price_discount/100.0
        errors.add(:price, "Цена предожения слишком маленькая") unless offer.price_etalon.between?(price_in_currency, Float::INFINITY)
      end
    end

    def weight_validate
      errors.add(:user_id) if offer.weight_etalon < position.weight_min_etalon
    end

    def regenerate_cache
      Rails.cache.delete("user_offers_#{self.offer.user_id}_#{I18n.locale}")
    end
end
