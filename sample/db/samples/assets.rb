# frozen_string_literal: true

require 'thor'
shell = Thor::Base.shell.new

Spree::Sample.load_sample("products")
Spree::Sample.load_sample("variants")

products = {}
products[:solidus_tshirt] = Spree::Product.includes(variants: [:option_values]).find_by!(name: "Solidus T-Shirt")
products[:solidus_long] = Spree::Product.includes(variants: [:option_values]).find_by!(name: "Solidus Long Sleeve")
products[:solidus_womens_tshirt] = Spree::Product.includes(variants: [:option_values]).find_by!(name: "Solidus Women's T-Shirt")
products[:solidus_snapback_cap] = Spree::Product.find_by!(name: "Solidus Snapback Cap")
products[:solidus_hoodie] = Spree::Product.find_by!(name: "Solidus Hoodie Zip")
products[:ruby_hoodie] = Spree::Product.find_by!(name: "Ruby Hoodie")
products[:ruby_hoodie_zip] = Spree::Product.find_by!(name: "Ruby Hoodie Zip")
products[:ruby_polo] = Spree::Product.find_by!(name: "Ruby Polo")
products[:solidus_mug] = Spree::Product.find_by!(name: "Solidus Mug")
products[:ruby_mug] = Spree::Product.find_by!(name: "Ruby Mug")
products[:solidus_tote] = Spree::Product.find_by!(name: "Solidus Tote")
products[:ruby_tote] = Spree::Product.find_by!(name: "Ruby Tote")

image = ->(name, type = "jpg") do
  images_path = Pathname.new(File.dirname(__FILE__)) + "images"
  path = images_path + "#{name}.#{type}"

  return false if !File.exist?(path)

  path
end

images = {
  products[:solidus_snapback_cap].master => [
    {
      attachment: image["solidus_snapback_cap"]
    }
  ],
  products[:solidus_hoodie].master => [
    {
      attachment: image["solidus_hoodie"]
    }
  ],
  products[:ruby_hoodie].master => [
    {
      attachment: image["ruby_hoodie"]
    }
  ],
  products[:ruby_hoodie_zip].master => [
    {
      attachment: image["ruby_hoodie_zip"]
    }
  ],
  products[:ruby_polo].master => [
    {
      attachment: image["ruby_polo"]
    },
    {
      attachment: image["ruby_polo_back"]
    }
  ],
  products[:solidus_mug].master => [
    {
      attachment: image["solidus_mug"]
    }
  ],
  products[:ruby_mug].master => [
    {
      attachment: image["ruby_mug"]
    }
  ],
  products[:solidus_tote].master => [
    {
      attachment: image["tote_bag_solidus"]
    }
  ],
  products[:ruby_tote].master => [
    {
      attachment: image["tote_bag_ruby"]
    }
  ]
}

products[:solidus_tshirt].variants.each do |variant|
  color = variant.option_value("tshirt-color").downcase
  main_image = image["solidus_tshirt_#{color}", "png"]
  File.open(main_image) do |f|
    variant.images.create!(attachment: f)
  end
  back_image = image["solidus_tshirt_back_#{color}", "png"]

  next unless back_image

  File.open(back_image) do |f|
    variant.images.create!(attachment: f)
  end
end

products[:solidus_long].variants.each do |variant|
  color = variant.option_value("tshirt-color").downcase
  main_image = image["solidus_long_#{color}", "png"]
  File.open(main_image) do |f|
    variant.images.create!(attachment: f)
  end
  back_image = image["solidus_long_back_#{color}", "png"]

  next unless back_image

  File.open(back_image) do |f|
    variant.images.create!(attachment: f)
  end
end

products[:solidus_womens_tshirt].reload.variants.each do |variant|
  color = variant.option_value("tshirt-color").downcase
  main_image = image["solidus_womens_tshirt_#{color}", "png"]
  File.open(main_image) do |f|
    variant.images.create!(attachment: f)
  end
end

images.each do |variant, attachments|
  shell.say_status :sample, "images for #{variant.product.name}"
  attachments.each do |attachment|
    File.open(attachment[:attachment]) do |f|
      variant.images.create!(attachment: f)
    end
  end
end
