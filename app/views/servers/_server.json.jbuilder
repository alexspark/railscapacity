json.extract! server, :id, :provider, :instance_type, :paas, :vps, :cpu, :dedicated_cpu, :ram, :price_per_month, :created_at, :updated_at
json.url server_url(server, format: :json)
