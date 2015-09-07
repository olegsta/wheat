class WeightDimension < ActiveRecord::Base

  after_commit :regenerate_cache

  DIMENSIONS = [
    { id: 1, convert: 1, name: "kg" },
    { id: 2, convert: 1000, name: "tonn" },
    { id: 3, convert: 1, name: "liter"},
    { id: 4, convert: 1000, name: "m3"},
    { id: 5, convert: 28.31, name: "ft3" }
  ]

  def self.normalize weight, weight_dimension_id
    weight.to_f * WeightDimension.by_index_from_cache[weight_dimension_id][:convert]
  end

  def self.by_index_from_cache
    Rails.cache.fetch("dimensions_by_index_#{I18n.locale}") do
      ActiveModel::ArraySerializer.new(WeightDimension.all, each_serializer: WeightDimensionSerializer).as_json.index_by {|wd| wd[:id]}
    end
  end

  def self.all_from_cache
    Rails.cache.fetch("dimensions_all_#{I18n.locale}") do
      WeightDimension.all.load
    end
  end

  private
    def regenerate_cache
      Rails.cache.delete("dimensions_by_index_#{I18n.locale}")
      Rails.cache.delete("dimensions_all_#{I18n.locale}")
    end
  
end
