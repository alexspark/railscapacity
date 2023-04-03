class CreateServers < ActiveRecord::Migration[7.0]
  def change
    create_table :servers do |t|
      t.string :provider
      t.string :instance_type
      t.boolean :paas
      t.boolean :vps
      t.decimal :cpu, precision: 10, scale: 2
      t.boolean :dedicated_cpu
      t.integer :ram
      t.integer :price_per_month_cents

      t.timestamps
    end
  end
end
