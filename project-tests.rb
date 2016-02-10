require_relative 'airport'
require 'sqlite3'

describe Airport::Flight do

end

describe Airport::Admin do
  admin = Airport::Admin.new('admin')

  describe '#login' do
    it 'can log in successfully' do
      expect(admin.login('bla').logged).to eq false
      expect(admin.login('password').logged).to eq true
    end
  end

  describe '#promote' do
    it 'can create new admins' do
      promoted_admin = admin.promote('new_admin', 'new_password')
      expect(promoted_admin.login('new_password').logged).to eq true
    end
    SQLite3::Database.open 'Airport.db' do |db|
      db.execute "DELETE FROM Admins WHERE Username = 'new_admin'"
    end
  end

  describe '#logout' do
    it 'can log out successfully' do
      expect(admin.logout.logged).to eq false
    end
  end

  describe '#change_password'do
    it 'changes the password successfully' do
      admin.change_password('bla')
      expect(admin.login('bla').logged).to eq true
      admin.change_password('password')
    end
  end
end

describe Airport::DatabaseOperations do
  describe '#query' do
    it 'returns the right data' do
      SQLite3::Database.open 'Airport.db' do |db|
        db.execute "INSERT INTO Flights VALUES (-1, 'Sofia',
                                                'Bulgaria Air', 'departing',
                                                '01:00', '02:00', 'On time',
                                                120, '', 'false')"
      end

      expect(Airport::DatabaseOperations.query(-1, 'Price')).to eq 120 
      SQLite3::Database.open 'Airport.db' do |db|
        db.execute "DELETE FROM Flights WHERE Id=-1"
      end
    end
  end

  describe '#get_row_by_flight_number' do
    it 'returns the right data' do
      SQLite3::Database.open 'Airport.db' do |db|
        db.execute "INSERT INTO Flights VALUES (-1, 'Sofia',
                                              'Bulgaria Air', 'departing',
                                              '01:00', '02:00', 'On time',
                                              120, '', 'false')"
        end

      desired_row = [-1, 'Sofia', 'Bulgaria Air', 'departing', '01:00', '02:00', 'On time', 120, '', 'false']
      
      expect(Airport::DatabaseOperations.get_row_by_flight_number(-1)).to eq desired_row
      SQLite3::Database.open 'Airport.db' do |db|
        db.execute "DELETE FROM Flights WHERE Id=-1"
      end
    end
  end
end

describe Airport::Finances do
  describe '#earn_money' do
    it 'adds 20% of the ticket price to the financial state' do
      old_balance = Airport::Finances.check_balance

      Airport::Finances.earn_money(100)
      expect(Airport::Finances.check_balance).to eq (old_balance + 20)
      
      #update_balance method is also tested in this example
      Airport::Finances.update_balance(old_balance)
      expect(Airport::Finances.check_balance).to eq old_balance
    end 
  end
end

describe Airport::Guest do
  describe '#check_flight_status' do
    it 'returns the accurate status' do
      SQLite3::Database.open 'Airport.db' do |db|
        db.execute "INSERT INTO Flights VALUES (-1, 'Sofia',
                                                'Bulgaria Air', 'departing',
                                                '01:00', '02:00', 'On time',
                                                120, '', 'false')"
      end

      expect(Airport::Guest.new.check_flight_status(-1)).to eq 'On time'

      SQLite3::Database.open 'Airport.db' do |db|
        db.execute "DELETE FROM Flights WHERE Id=-1"
      end
    end
  end
end
