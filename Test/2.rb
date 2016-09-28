a = []
loop do
  print "enter next name: "
  name = gets.chomp
  puts
  if name == 'quit'
    break
  else
    a << name
  end
end
puts
puts "Sorted list:"
a.sort.each{|n| puts n}
puts
puts "Sorted list with reversed name for even positions :"
a.sort.each_with_index{|n, i| puts i.odd? ? n.reverse : n}
