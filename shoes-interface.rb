require 'shoes'
require_relative 'airport'

user_options = ['Guest', 'Admin', 'Exit']

Shoes.app title: "Ruby implemented airport", width: 800, height: 600 do

=begin
  admin_interface = window do
    username = ask "Enter username"
    password = ask "Enter password"

    button "Add flight" do
      destination = ask "Enter destination: "
      type = ask "Enter type (arriving/departing): "
      departure = ask "Enter time of departure (hh:mm): "
      arrival = ask "Enter time of arrival (hh:mm): "
      company = ask "Enter the flight company name: "
      price = ask "Enter flight price: "

      admin.add_flight(destination, type, company, departure, arrival, price)
      alert "Flight successfully added"
    end

    button "Go back" do
      close
    end
  end
  admin_interface.hide
=end

  @welcome = stack do
    para 'What type of user are you?'
    flow do
      button 'Guest' do
        @guest_interface = stack do
          guest = Airport::Guest.new
          para "What would you like to do?"

          flow do
            button "View flight table" do
              flights = guest.view_all_flights
              window title: 'Flights' do
                if flights == []
                  alert "No flights to show"
                else
                  flights.each { |f| para f }
                end
              end
            end

            button "View flights from" do
              destination = ask "Enter destination: "
              flights = guest.view_flights_by_attribute('Arriving', destination)
              if flights == []
                alert "No flights to show"
              else
                window title: "Flights from #{destination}" do
                  flights.each { |f| para f }
                end
              end
            end

            button "View flights to" do
              destination = ask "Enter destination: "
              flights = guest.view_flights_by_attribute('Departing', destination)
              if flights == []
                alert "No flights to show"
              else
                window title: "Flights to #{destination}" do
                  flights.each { |f| para f }
                end
              end
            end

            button "Check flight status" do
              id = ask "Enter flight id: "
              status = Airport::DatabaseOperations.query(id, 'Status')
              alert status, title: "Flight status is"
            end

            button "Buy ticket" do
              id = ask "Enter flight id"
              guest.buy_ticket(id)
              alert "Ticket bought successfully"
            end

            button "Go back" do
              @guest_interface.remove 
            end
          end
        end
      end
    
      button 'Admin' do
        @login = stack do
          username = ask "Enter username"
          password = ask "Enter password", secret: true

          admin = Airport::Admin.new(username)
          admin.login(password)
          if admin.logged
            alert "Logged in successfully"
            @admin_interface = stack do
              para "What would you like to do?"
              flow do
                button "Add flight" do
                  destination = ask "Enter destination: "
                  type = ask "Enter type (arriving/departing): "
                  departure = ask "Enter time of departure (hh:mm): "
                  arrival = ask "Enter time of arrival (hh:mm): "
                  company = ask "Enter the flight company name: "
                  price = ask "Enter flight price: "

                  admin.add_flight(destination, type, company, departure, arrival, price)
                  alert "Flight successfully added"
                end

                button "Remove flight" do
                  id = ask "Enter flight id"
                  admin.remove_flght(id)
                end

                button "Change flight status" do
                  id = ask "Enter flight id"
                  new_status = ask "Enter new status"
                  admin.change_flight_information(id, 'Status', new_status)
                end
                  
                button "Change flight schedule" do
                  id = ask "Enter flight id"
                  new_departure = ask "Enter new departure time"
                  new_arrival = ask "Enter new arrival time"
                  admin.change_flight_information(id, 'Departure', new_departure)
                  admin.change_flight_information(id, 'Arrival', new_arrival)
                end

                button "View flight table" do
                  flights = admin.view_all_flights
                  window title: 'Flights' do
                    if flights == []
                      alert "No flights to show"
                    else
                      stack do
                        flights.each { |f| para f }
                      end
                    end
                  end
                end

                button "View all the changes for a flight" do
                  id = ask "Enter flight id"
                  window title: "Changes for flight with id #{id}" do
                    para admin.view_changes(id)
                  end
                end

                button "Promote new admin" do
                  new_username = ask "Enter the new admin's username"
                  new_password = ask "Enter the new admin's password", secret: true
                  admin.promote(new_username, new_password)
                end

                button "Check financial state" do
                  alert "Money earned so far: #{admin.check_balance}"
                end

                button "Change password" do
                  new_password = ask "Enter new password", secret: true
                  admin.change_password(new_password)
                end
                button "Logout" do
                  @admin_interface.remove
                end
              end
            end
          else
            alert "Incorrect username/password combination"
          end
        end
      end

      button 'Exit' do
        close
      end
    end
  end
end
