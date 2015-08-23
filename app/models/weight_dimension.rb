class WeightDimension < ActiveRecord::Base

  after_create :regenerate_cache

  DIMENSIONS = [
    { id: 1, convert: 1, name: "kg" },
    { id: 2, convert: 1000, name: "tonn" },
    { id: 3, convert: 1, name: "liter"},
    { id: 4, convert: 1000, name: "m3"},
    { id: 5, convert: 28.31, name: "ft3" }
  ]

  def self.normalize weight, weight_dimension_id
    weight.to_f * WeightDimension.dimensions[weight_dimension_id].convert
  end

  def self.dimensions
    Rails.cache.fetch("dimensions") do
      WeightDimension.all.index_by {|wd| wd.id}
    end
  end

  private
    def regenerate_cache
      Rails.cache.delete("dimensions")
    end
  
end
