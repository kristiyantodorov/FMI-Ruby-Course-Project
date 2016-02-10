class Airport::Guest < Airport::User
  def view_flights_by_attribute(direction, destination)
    SQLite3::Database.open 'Airport.db' do |db|
      db.execute "SELECT * FROM Flights
                    WHERE Type = '#{direction}' AND
                          Destination = '#{destination}'" do |row|
        flights = Array.new.tap do |f|
          f << row.map{ |e| e.to_s }.first(8).join(', ')
        end

        return flights
      end
    end
  end

  def view_flights_to(destination)
    SQLite3::Database.open 'Airport.db' do |db|
      db.execute "SELECT * FROM Flights
                  WHERE Destination = #{destination} AND
                        Type = 'departing'" do |row|
        flights = Array.new.tap do |f|
          f << row.map{ |r| r.to_s }.first(8).join(',')
        end

        return flights
      end
    end
  end

  def check_flight_status(flight_id)
    Airport::DatabaseOperations.query(flight_id, 'Status')
  end

  def buy_ticket(flight_id)
    price = Airport::DatabaseOperations.query(flight_id, 'Price')
    Airport::Finances.earn_money(price)
  end
end
