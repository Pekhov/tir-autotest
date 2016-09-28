#coding: utf-8
print "Введите значения через запятую: "
arr = gets.chomp.split(',').to_a
def minimum(array)
  min = array[0]
  array.select{|x| min = x if x < min}
end
puts "Минимальный элемент = #{minimum(arr)}"