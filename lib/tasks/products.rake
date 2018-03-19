MyProducts = [
  {
    name: "Cuenta Tutor Básico",
    category: "plan",
    description:"basic account tutor"
  },
  {
    name: "Cuenta Tutor Premium",
    category: "plan",
    description:"premium account tutor"
  }
]

namespace :products do
  task create: :environment do
    products_db = Product.all.map(&:name)
    MyProducts.each do |product|
      unless products_db.include?(product[:name])
        Product.create!(product)
        puts "Product: #{product[:name]}"
      end
    end
  end
end
