class Airport::Flight
  attr_accessor :id, :company, :departure, :arrival, :status, :price, :destination, :type
  attr_reader :changes

  def initialize
    @status = 'On time'
    @changes = ''
    @deleted = 'false'
  end

  def write_to_database
    db = SQLite3::Database.open 'Airport.db'
    db.execute "CREATE TABLE IF NOT EXISTS Flights(Id INTEGER primary key,
                                                   Destination TEXT,
                                                   Company TEXT,
                                                   Type TEXT,
                                                   Departure TEXT,
                                                   Arrival TEXT,
                                                   Status TEXT,
                                                   Price REAL,
                                                   Changes TEXT,
                                                   Deleted TEXT)"

    db.execute "INSERT INTO Flights VALUES(NULL, '#{@destination}',
                                           '#{@company}', '#{@type}',
                                           '#{@departure}', '#{@arrival}',
                                           '#{@status}', '#{@price}',
                                           '#{@changes}', '#{@deleted}')"
  end
end
