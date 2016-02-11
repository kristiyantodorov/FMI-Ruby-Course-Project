class Airport::User
  def view_all_flights
    flights = []
    SQLite3::Database.open 'Airport.db' do |db|
      db.execute("SELECT * FROM Flights WHERE Deleted = 'false'") do |row|
        flights << row.map{ |e| e.to_s }.first(8).join(', ')
      end
    end
    return flights
  end
end
