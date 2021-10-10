class AddIndexToPropertyCoordinates < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL.squish
      CREATE INDEX properties_on_coordinates ON properties
      USING gist (earth_box(ll_to_earth(lat, lng), 5000));
    SQL
  end

  def down
    execute "DROP INDEX properties_on_coordinates;"
  end
end
