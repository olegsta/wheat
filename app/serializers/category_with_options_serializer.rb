class CategoryWithOptionsSerializer < CategorySerializer
  attributes :id, :options
  has_many :options, serializer: OptionSerializer
end
