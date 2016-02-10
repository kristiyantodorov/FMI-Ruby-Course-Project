module Airport::Finances
  module_function

  def update_balance(ammount)
    SQLite3::Database.open 'Airport.db' do |db|
      db.execute "UPDATE Finances
                    SET Balance = #{ammount}"
    end
  end

  def initialize_if_empty
    SQLite3::Database.open 'Airport.db' do |db|
      db.execute "CREATE TABLE IF NOT EXISTS Finances(Balance REAL DEFAULT (0.0))"
      rows_count = (db.execute "SELECT COUNT (*) FROM Finances").first.first
      if  rows_count == 0
        db.execute "INSERT INTO Finances VALUES (0)"
      end
    end
  end

  def check_balance
    initialize_if_empty
    SQLite3::Database.open 'Airport.db' do |db|
      db.execute "SELECT Balance FROM Finances" do |balance|
        return balance.first
      end
    end
  end

  def earn_money(ticket_price)
    income = 0.20 * ticket_price
    new_balance = check_balance + income
    update_balance(new_balance)
  end
end
