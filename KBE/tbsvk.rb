#coding: utf-8

require 'stomp'
#Задаем пути к файлам
request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-TBSVK\request.xml' #Путь к файлу с запросом
response_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-TBSVK\response.xml' #Путь к файлу с ответом
response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-TBSVK\fact\response_fact.xml' #Путь к файлу с фактическим ответом из ТИР
10.times do
request = File.open(request_path){|file| file.read}
file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
client = Stomp::Client.new("admin", "admin", "vm-corint", 61613)
client.publish("/queue/correqts220_in", request) #Кидаем запрос в очередь
client.subscribe("/queue/tbsvk_out"){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
client.join(1)
client.close
#Отключаемся от MQ
file_fact.close
#Сравниваем эталонный ответ с фактическим
file_etalon = File.open(response_path){ |file| file.read }
file_fact = File.open(response_fact_path){ |file| file.read }
if file_etalon == file_fact
  puts "Маршрут работает (response.xml==response_fact.xml)"
else
  puts "Маршрут не работает"
end
end
