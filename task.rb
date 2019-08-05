class Station

  def initialize(name)
    @name = name
    @trains = [] 
  end
 
  attr_reader :trains, :name 
  
  def accept_train(train)
    # нужно ли обращаться к геттеру через self.trains
    # насколько приемлимо использовать похожие названия train и trains ? 
    if !trains.include?(train)
      trains.push(train) 
      # Нужно ли останавливать поезд в этом методе ? 
      train.stop
      puts "Train ##{train.id} is arrieved to #{@name}"
    else 
      puts 'Train is already here!'
  end

  # Настораживает вопрос согласованности данных и взаимодействия классов 
  # Метод accept_train останавливает поезд 
  # Метод depart_train вызывается методами go_next и go_back класса Train 
  ## Будучи вызванным сам по себе depart_train не произведет корректного изменения состояния текущей точки маршрута поезда

  def depart_train(train)
    if trains.include?(train)
      trains.delete(train)
      puts "Train ##{train.id} is departed from #{@name}"
    else 
      puts 'No such train at this station!'
    end
  end

  def trains_at_station 
    passenger_count = 0 
    freight_count = 0 
    unknown_count = 0 
    trains.each do |train|
      if train.type == "passenger"
        passenger_count += 1 
      elsif train.type == "freight"
        freight_count += 1 
      else 
        unknown_count += 1 
      end
    end   

    puts "Trains on station \"#{@name}\": \nPassenger trains: #{passenger_count}\nFreight trains: #{freight_count}"
    
    puts "Unknown trains: #{unknown_count}" unless unknown_count == 0 

  end
  
end

class Route 

  def initialize(first, last)
    @route_list = [first, last]
  end

  def add_station(station)
    @route_list.insert(@route_list.size - 1, station)
  end

  def print_route 
    @route_list.each do |station|
      puts "> #{station.name}"
    end
  end

  def route_list
    @route_list 
  end

end


class Train 

  def initialize(id, type, carriages)
    @id = id
    @type = type 
    @carriages = carriages
    @speed = 0 
    @route = [] 
  end

  attr_reader :speed, :carriages, :type, :current_station, :next_station, :prev_station, :id, :route


  def route=(route)
    @route = route
    @current_station_index = 0
    @current_station = route.route_list[@current_station_index]
    @next_station = route.route_list[@current_station_index + 1]
    @current_station.accept_train(self)
    self.stop
  end

  def speedup 
    @speed += 10 
  end

  def stop
    @speed = 0 
  end

  def add_car
    @carriages += 1 
  end

  def remove_car
    if @carriages > 0 
      @carriages -= 1
    else 
      puts 'There is no carriages already'
    end
  end

  def go_next
    
    if @next_station
      # Согласованность данных? нужно ли производить отправление со станции в этом методе? 
      route.route_list[@current_station_index].depart_train(self)
      self.speedup

      @prev_station = route.route_list[@current_station_index]
      @current_station_index += 1 
      @current_station = @route.route_list[@current_station_index]

      if @current_station_index == route.route_list.size - 1 
        @next_station = route.route_list[@current_station_index + 1]
      else 
        @next_station = nil 
      end
    else 
      puts 'End of route! Can\'t go further!'
    end
  end

  def go_back
    
    if @prev_station
      # Согласованность данных? нужно ли производить отправление со станции в этом методе? 
      route.route_list[@current_station_index].depart_train(self)
      self.speedup

      @next_station = route.route_list[@current_station_index]
      @current_station_index -= 1 
      @current_station = route.route_list[@current_station_index]

      if @current_station_index > 0 
        @prev_station = route.route_list[@current_station_index - 1]
      else 
        @prev_station = nil 
      end
    else 
      puts 'Start of route! Can\'t go back!'
    end
 
  end
end

train1 = Train.new("636-1", "freight", 23)
train2 = Train.new("221-2", "freight", 44)
train3 = Train.new("367-3", "freight", 12)
train4 = Train.new("12-4", "passenger", 14)
train5 = Train.new("9889-5", "passenger", 8)
train6 = Train.new("01223-6", "passenger", 16)

station1 = Station.new("Mirnaya")
station2 = Station.new("Tomilovo")
station3 = Station.new("Himik")
station4 = Station.new("Chapayevskaya")
station5 = Station.new("Kirova")
station6 = Station.new("Vladimir")
station7 = Station.new("Kazan gruzovoy-1")
station8 = Station.new("CSKB Progress")

route1 = Route.new(station8, station7)
route2 = Route.new(station7, station8)

train1.route = route1 
train2.route = route2 

puts "============================"

puts "checking initial stations state ... "
station1.trains_at_station
station2.trains_at_station
station3.trains_at_station
station4.trains_at_station
station5.trains_at_station
station6.trains_at_station
station7.trains_at_station
station8.trains_at_station
puts "============================"

train1.go_next
train2.go_next
puts "train1 departed from: #{train1.prev_station.name} and speeded up to: #{train1.speed}"
puts "train2 departed from: #{train2.prev_station.name} and speeded up to: #{train2.speed}"
# будет сообщение "No such train at this station" так как мы развернули поезд до того как он прибыл 
puts "\ntelling train2 to go_back before it arrives next station ..."
train2.go_back
# train.curreint_station - станция в направлении которой поезд едет 
puts "train2 target(current) station: #{train2.current_station.name}\n" 
train2.current_station.accept_train(train2)


route3 = Route.new(station4, station1)
train6.route = route3 
route3.add_station(station3)

puts "\nupdated route3: "
train6.route.print_route

train6.go_next 
# Проверяем что поезд приедет именно в промежуточную станцию 
puts "\nchecking arrival of train6 to middle station ..\n"
train6.current_station.accept_train(train6)

end
