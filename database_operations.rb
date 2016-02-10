class Airport::DatabaseOperations
  class << Airport::DatabaseOperations
    def query(flight_id, element)
      SQLite3::Database.open 'Airport.db' do |db|
        db.execute "SELECT #{element} FROM Flights WHERE Id = #{flight_id}" do |element|
          return element.first
        end
      end
    end

    def get_row_by_flight_number(flight_id)
      SQLite3::Database.open 'Airport.db' do |db|
        db.execute "SELECT * FROM Flights WHERE Id = #{flight_id}" do |row|
          return row
        end
      end
    end

    def make_change(flight_id, type_of_change, new_value, admin_name)
      time_of_change = Time.now
      old_value = query(flight_id, type_of_change)
      author = admin_name

      change_message = "#{author} changed #{type_of_change} from " +
        "#{old_value} to #{new_value} at #{time_of_change.to_s}\n"

      old_changes = query(flight_id, 'Changes')
      new_changes = change_message + old_changes

      update(flight_id, type_of_change, new_value)
      update(flight_id, 'Changes', new_changes)
    end

    private

    def update(flight_id, element, new_value)
      SQLite3::Database.open 'Airport.db' do |db|
        db.execute "UPDATE Flights
                      SET #{element} = '#{new_value}'
                      WHERE Id = #{flight_id}"
      end
    end
  end
end
