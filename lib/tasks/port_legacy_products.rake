namespace :port_legacy_products do
  desc "Assign the first category to all existing products"

  task assign_category: :environment do
    first_category = Category.first

    if first_category.nil?
      puts "No categories found. Please create a category first."
      next
    end

    Product.find_each do |product|
      product.update!(category: first_category)
    end

    puts "Successfully assigned #{first_category.name} to all products."
  end
end
