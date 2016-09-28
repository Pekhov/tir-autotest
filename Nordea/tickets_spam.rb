#coding: utf-8

require 'stomp'
#Задаем пути к файлам
request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\DocIds_request.xml' #Путь к файлу с запросом

request = File.open(request_path){|file| file.read}

#Подключаемся к MQ
#n=0
10000.times do
client = Stomp::Client.new("admin", "admin", "msk01tir01", 61613)
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.publish("/queue/correqts_in", request) #Кидаем запрос в очередь
client.close
#sleep 0.02
#p n+=1
end