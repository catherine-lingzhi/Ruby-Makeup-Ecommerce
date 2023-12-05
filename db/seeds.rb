# require "net/http"
# require "json"
# require "uri"
# require "faker"
# require "open-uri"

# Product.delete_all
# Category.delete_all
# AdminUser.delete_all
# Province.delete_all

# # Helper function to validate image link
# def valid_image_link?(image_link)
#   uri = URI(image_link)
#   response = Net::HTTP.get_response(uri)
#   response.code.to_i == 200
# rescue Errno::ECONNREFUSED, SocketError
#   puts "Error: Failed to connect to the image link: #{image_link}"
#   false
# end

# # Helper function to check if description contains HTML tag
# def description_has_html_tag?(description)
#   !!(description =~ %r{</?[a-z][\s\S]*>})
# end

# # Fetch API to populate data to the database
# url = "http://makeup-api.herokuapp.com/api/v1/products.json"
# uri = URI(url)
# response = Net::HTTP.get(uri)
# data = JSON.parse(response)

# # Counter to limit the number of products
# products_created = 0
# desired_product_limit = 300

# data.each do |product_data|
#   break if products_created >= desired_product_limit

#   category = Category.find_or_create_by(name: product_data["product_type"])

#   if category && category.valid?
#     image_link = product_data["image_link"]

#     if valid_image_link?(image_link) && !description_has_html_tag?(product_data["description"])
#       # db/seeds.rb
#       product = category.products.create(
#         name:        product_data["name"],
#         price:       product_data["price"],
#         description: product_data["description"]
#       )

#       # Download and attach the image using Active Storage
#       image_io = URI.open(image_link)
#       product.image.attach(io: image_io, filename: "product_image.jpg")

#       products_created += 1
#     else
#       puts "Invalid image link: #{image_link}"
#     end
#   else
#     puts "Invalid category #{product_data['product_type']}"
#   end
# end

# Province.create!([{
#                    name: "Alberta",
#                    GST:  0.05
#                  },
#                   {
#                     name: "British Columbia",
#                     GST:  0.05,
#                     PST:  0.07
#                   },
#                   {
#                     name: "Manitoba",
#                     GST:  0.05,
#                     PST:  0.07
#                   },
#                   {
#                     name: "New Brunswick",
#                     HST:  0.15
#                   },
#                   {
#                     name: "Newfoundland and Labrador",
#                     HST:  0.15
#                   },
#                   {
#                     name: "Northwest Territories",
#                     GST:  0.05
#                   },
#                   {
#                     name: "Nova Scotia",
#                     HST:  0.15
#                   },
#                   {
#                     name: "Nunavut",
#                     GST:  0.05
#                   },
#                   {
#                     name: "Ontario",
#                     HST:  0.13
#                   },
#                   {
#                     name: "Prince Edward Island",
#                     HST:  0.15
#                   },
#                   {
#                     name: "Quebec",
#                     GST:  0.05,
#                     QST:  0.0975
#                   },
#                   {
#                     name: "Saskatchewan",
#                     GST:  0.05,
#                     PST:  0.06
#                   }])

# puts "Created #{Category.count} categories"
# puts "Created #{Product.count} products"

# if Rails.env.development?
#   AdminUser.create!(email: "admin@example.com", password: "password",
#                     password_confirmation: "password")
# end
OrderStatus.create(name: "new")
OrderStatus.create(name: "Paid")
OrderStatus.create(name: "Shipped")
