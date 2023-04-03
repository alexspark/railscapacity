# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
#
#   Instance
#   - provider
#   - instance_type (lightsail, cpu optimized, memory, storage)
#   - cpu
#   - dedicated_cpu
#   - ram
#   - price per hour
#   - price per month
#

seed_data_path = Rails.root.join('db', 'hosting-providers.csv')

require 'csv'

hosting_providers = CSV.parse(File.read(seed_data_path), headers: true)

hosting_providers.each do |hp|
  Server.create(
    provider: hp['provider'],
    instance_type: hp['instance_type'],
    paas: hp['paas'] == '1',
    vps: hp['vps'] == '1',
    cpu: hp['cpu'],
    dedicated_cpu: hp['dedicated_cpu'] == '1',
    ram: hp['ram'],
    price_per_month_cents: hp['price_per_month'],
  )
end


