class Airport::User
  def view_all_flights
    SQLite3::Database.open 'Airport.db' do |db|
      db.execute("SELECT * FROM Flights WHERE Deleted = 'false'") do |row|
        puts row.map{ |e| e.to_s }.first(8).join(', ')
      end
    end
  end
end
