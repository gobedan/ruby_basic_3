class Station

  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains = [] 
  end
 
  def accept_train(train) 
    trains.push(train) unless trains.include?(train)
  end

  def depart_train(train)
    trains.delete(train) if trains.include?(train)
  end

  def trains_by_type(type)
    return trains.collect { |train|  train if train.type == type }  
  end
end

class Route 

  attr_reader :route_list

  def initialize(first, last)
    @route_list = [first, last]
  end

  def add_station(station)
    @route_list.insert(@route_list.size - 1, station)
  end
end

class Train 

  attr_reader :speed, :carriages, :type, :next_station, :id, :route

  def initialize(id, type, carriages)
    @id = id
    @type = type 
    @carriages = carriages
    @speed = 0  
  end

  def route=(route)
    @route = route
    @current_station_index = 0 
    current_station.accept_train(self)
    stop
  end

  def current_station
    route.route_list[@current_station_index]
  end

  def next_station
    route.route_list[@current_station_index + 1]
  end

  def prev_station
    route.route_list[@current_station_index -1]
  end

  def speedup 
    @speed += 10 
  end

  def stop
    @speed = 0 
  end

  def add_carriage
    @carriages += 1 
  end

  def remove_carriage
    @carriages -= 1 if @carriages > 0 
  end

  def go_next
    if next_station
      current_station.depart_train(self)
      speedup
      @current_station_index += 1 
    end
  end

  def go_back  
    if prev_station
      current_station.depart_train(self)
      speedup
      @current_station_index -= 1
    end
  end
end

train1 = Train.new("636-1", :freight, 23)
train2 = Train.new("221-2", :freight, 44)
train3 = Train.new("367-3", :freight, 12)
train4 = Train.new("12-4", :passenger, 14)
train5 = Train.new("9889-5", :passenger, 8)
train6 = Train.new("01223-6", :passenger, 16)

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
puts station1.trains_by_type(:passenger)
puts station1.trains_by_type(:freight)
puts station7.trains_by_type(:freight)
puts station8.trains_by_type(:freight)
puts "============================"

train1.go_next
train2.go_next
puts "train1 departed from: #{train1.prev_station.name} and speeded up to: #{train1.speed}"
puts "train2 departed from: #{train2.prev_station.name} and speeded up to: #{train2.speed}"
# будет сообщение "No such train at this station" так как мы развернули поезд до того как он прибыл 
puts "\ntelling train2 to go_back before it arrives next station ..."
train2.go_back
# train.current_station - станция в направлении которой поезд едет 
puts "train2 target(current) station: #{train2.current_station.name}\n" 
train2.current_station.accept_train(train2)


route3 = Route.new(station4, station1)
train6.route = route3 
route3.add_station(station3)

puts "\nupdated route3: "
puts train6.route.route_list

train6.go_next 
# Проверяем что поезд приедет именно в промежуточную станцию 
puts "\nchecking arrival of train6 to middle station ..\n"
train6.current_station.accept_train(train6)
puts train6.current_station
