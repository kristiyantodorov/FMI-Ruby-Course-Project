module Airport::AdminOperations
  def add_flight(destination, type, company, departure, arrival, price)
    flight = Airport::Flight.new
    flight.destination = destination
    flight.type = type
    flight.company = company
    flight.price = price
    flight.departure = departure
    flight.arrival = arrival

    flight.write_to_database
    flight
  end

  def change_flight_information(flight_id, type_of_change, new_value)
    Airport::DatabaseOperations.make_change(flight_id, type_of_change, new_value, username)
  end

  def remove_flight(flight_id)
    Airport::DatabaseOperations.make_change(flight_id, 'Deleted', 'true', username)
  end

  def check_balance
    Airport::Finances.check_balance
  end

  def view_changes(flight_id)
    Airport::DatabaseOperations::query(flight_id, 'Changes')
  end
end
