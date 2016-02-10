require_relative 'airport'

module ConsoleInterface
  include Airport
  module_function

  def greeting
    puts "Welcome to the Ruby implemented airport software!"
    puts "What type of user are you?"
    puts "1. Guest.\n2. Admin"
    puts "3. Exit.\n"
    type = gets.chomp.to_i
    if type == 1
      GuestInterface::guest_greeting
    elsif type == 2
      AdminInterface::admin_greeting
    else
      puts "Have a nice day!\n"
    end
  end
  
  def get_id
    puts "Please enter flight id: "
    id = gets.chomp.to_i
  end
  
  def breaker
      puts "--------------------------------------------------------------------"
  end

  module AdminInterface
    module_function

    def admin_greeting
      puts "Please authorize.\nUsername: "
      username = gets.chomp
      puts "Password: "
      password = gets.chomp
      admin = Airport::Admin.new(username)
      admin_login(admin, password)
    end

    def admin_login(admin, password)
      admin.login(password)
      if admin.logged
        puts "Logged in successfully!\n"
        logged_admin_actions(admin)
      else
        puts "Incorrect username or password"
        puts "Would you like to try again? (y/n): "
        answer = gets.chomp
        if answer == 'y'
          admin_greeting
        else
          greeting
        end
      end
    end

    def admin_options
      ConsoleInterface::breaker
      puts "What would you like to do?\n"
      puts "1. Add flight.\n"
      puts "2. Remove flight.\n"
      puts "3. Change flight status.\n"
      puts "4. Change flight schedule.\n"
      puts "5. View flight table.\n"
      puts "6. View all the changes for a flight.\n"
      puts "7. Promote new admin.\n"
      puts "8. Check financial state.\n"
      puts "9. Change password.\n"
      puts "0. Logout.\n"
      ConsoleInterface::breaker
    end 

    def gather_flight_information(admin)
      puts "Enter destination: "
      destination = gets.chomp
      puts "Enter type (arriving/departing): "
      type = gets.chomp.capitalize
      puts "Enter time of departure (hh:mm): "
      departure = gets.chomp
      puts "Enter time of arrival (hh:mm): "
      arrival = gets.chomp
      puts "Enter the flight company name: "
      company = gets.chomp.capitalize
      puts "Enter flight price: "
      price = gets.chomp

      admin.add_flight(destination, type, company, departure, arrival, price)
    end

    def logged_admin_actions(admin)
      admin_options
      action = gets.chomp.to_i
      case action
      when 1
        gather_flight_information(admin)
        logged_admin_actions(admin)
      when 2
        id = ConsoleInterface::get_id
        admin.remove_flight(id)
        logged_admin_actions(admin)
      when 3
        id = ConsoleInterface::get_id
        puts "Please enter the new status: "
        new_status = gets.chomp
        admin.change_flight_information(id, 'Status', new_status)
        logged_admin_actions(admin)
      when 4
        id = ConsoleInterface::get_id
        puts "Please enter time of departure: "
        new_departure = gets.chomp
        puts "Please enter time of arrival: "
        new_arrival = gets.chomp
        admin.change_flight_information(id, 'Departure', new_departure)
        admin.change_flight_information(id, 'Arrival', new_arrival)
        logged_admin_actions(admin)
      when 5
        admin.view_all_flights
        logged_admin_actions(admin)
      when 6
        id = ConsoleInterface::get_id
        puts admin.view_changes(id)
        logged_admin_actions(admin)
      when 7
        puts "Enter new admin's username:\n"
        username = gets.chomp
        puts "Enter new admin's password:\n"
        password = gets.chomp
        admin.promote(username, password)
        logged_admin_actions(admin)
      when 8
        puts admin.check_balance
        logged_admin_actions(admin)
      when 9
        puts "Enter the new password:\n"
        password = gets.chomp
        admin.change_password(password)
        logged_admin_actions(admin)
      when 0
        admin.logout
        ConsoleInterface::greeting
      end
    end
  end

  module GuestInterface
    module_function

    def guest_greeting
      guest = Airport::Guest.new
      guest_actions(guest)
    end

    def guest_options
      ConsoleInterface::breaker
      puts "What would you like to do?\n"
      puts "1. View flight table.\n"
      puts "2. View flights from.\n"
      puts "3. View flights to.\n"
      puts "4. Check flight status.\n"
      puts "5. Buy ticket.\n"
      puts "6. Go back.\n"
      ConsoleInterface::breaker
    end

    def guest_actions(guest)
      guest_options
      action = gets.chomp.to_i
      
      case action
      when 1
        guest.view_all_flights
        guest_actions(guest)
      when 2
        puts "Enter destination: "
        destination = gets.chomp
        guest.view_flights_by_attribute('Arriving', destination)
        guest_actions(guest)
      when 3
        puts "Enter destination: "
        destination = gets.chomp
        guest.view_flights_by_attribute('Departing', destination)
        guest_actions(guest)
      when 4
        id = ConsoleInterface.get_id
        puts guest.check_flight_status(id)
        guest_actions(guest)
      when 5
        id = ConsoleInterface.get_id
        guest.buy_ticket(id)
        guest_actions(guest)
      when 6
        ConsoleInterface.greeting
      end
    end
  end

end

ConsoleInterface.greeting

