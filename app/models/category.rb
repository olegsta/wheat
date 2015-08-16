class Category < ActiveRecord::Base

  has_many :options

  CATEGORY = [ "berries",
      "bobs",
      "corn",
      "dairy",
      "dried fruit",
      "eggs",
      "fish",
      "fruits",
      "herbs",
      "mushrooms",
      "feed for animals",
      "oilseeds",
      "meat",
      "honey",
      "flour",
      "nuts",
      "vegetable oil",
      "seafood",
      "seed ang seedlings",
      "sugar",
      "vegetables",
      "wheat",
      "wood",
      "fertilizers and chemicals"]

end
