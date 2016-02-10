class Airport::Admin < Airport::User
  require 'digest/sha1'
  include Airport::AdminOperations

  attr_accessor :username, :logged

  def initialize(name = 'admin')
    @username = name
    @logged = false
  end

  def promote(name, password)
    new_admin = Airport::Admin.new(name)
    password = Digest::SHA1.hexdigest password
    new_admin.write_to_database(password)
    new_admin
  end

  def write_to_database(password)
    SQLite3::Database.open 'Airport.db' do |db|
      db.execute "CREATE TABLE IF NOT EXISTS Admins(Id INTEGER primary key,
                                                    Username TEXT,
                                                    Password TEXT)"

      db.execute "INSERT INTO Admins VALUES(NULL,
                                              '#{@username}',
                                              '#{password}')"
    end
  end

  def change_password(new_password)
    SQLite3::Database.open 'Airport.db' do |db|
      db.execute "UPDATE Admins
                    SET 'Password' = '#{Digest::SHA1.hexdigest new_password}'
                    WHERE Username = '#{@username}'"
    end

    self
  end

  def logout
    @logged = false
    self
  end

  def login(password)
    SQLite3::Database.open 'Airport.db' do |db|
      db.execute("SELECT DISTINCT Password FROM Admins
                    WHERE Username = '#{@username}'") do |pass|
        @logged = (Digest::SHA1.hexdigest password) == pass.first
      end

    end

    self
  end
end
