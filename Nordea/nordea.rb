#coding: utf-8
require 'stomp'
require 'savon'
require 'colorize'
require 'rexml/document'
include REXML

route = {
    'PayDocRu'          => true,
    'PayDocCur'         => false,
    'CurrBuy'           => false,
    'CurrSell'          => false,
    'CurrConv'          => false,
    'MandatorySaleBox'  => false,
    'DocIds'            => false,
    'StatementRequest'  => false,
    'NotifyStmReady'=> false,
    'NotifyStmReady940' =>false,
    'NotifyStmReadyClient' =>false,
    'CancelRequest'       => false,
    'NotifyClientChanged' => false,
    'Checks'              => false,
    'NotifyOrgDataMT940'  => false,
    'BankDocIds'          => false,
    'PinEnvelope'         => false,
    'ReviseRequest'       => false,
    'ReviseResponse'      => false}


# Очищаем очередь 1
client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
client.subscribe('/queue/nordea_out'){|msg| puts 'Очередь nordea_out очищена' if msg.body.to_s}
client.join(1)
client.subscribe('/queue/CqsClientChanged_Q'){|msg| puts 'Очередь CqsClientChanged_Q очищена' if msg.body.to_s}
client.join(1)
client.subscribe('/queue/STMNotificeBath_out'){|msg| puts 'Очередь STMNotificeBath_out очищена' if msg.body.to_s}
client.join(1)
client.close

################################################################################################################################################
puts "Запустили автотесты маршрутов в #{Time.now}"
if route['PayDocRu']
# Маршрут РПП
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\PayDocRu_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\fact\PayDocRu_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР
  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
  client.publish('/queue/nordea_in', request) #Кидаем запрос в очередь
  sleep 10
  client.subscribe('/queue/nordea_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close
#Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//cqa:Ticket'].attributes['statusStateCode'] == 'ACCEPTED_BY_ABS'
    puts 'РПП. Маршрут работает'
  else
    puts 'РПП. Маршрут не работает'.red
  end
end
################################################################################################################################################

if route['PayDocCur']
# Маршрут Перевод валюты
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\PayDocCur_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\fact\PayDocCur_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР
  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
  client.publish('/queue/nordea_in', request) #Кидаем запрос в очередь
  sleep 10
  client.subscribe('/queue/nordea_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close
#Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//cqa:Ticket'].attributes['statusStateCode'] == 'ACCEPTED_BY_ABS'
    puts 'Перевод валюты. Маршрут работает'
  else
    puts 'Перевод валюты. Маршрут не работает'.red
  end
end

################################################################################################################################################

if route['CurrBuy']
# Маршрут Покупки валюты
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\CurrBuy_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\fact\CurrBuy_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР
  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
  client.publish('/queue/nordea_in', request) #Кидаем запрос в очередь
  sleep 10
  client.subscribe('/queue/nordea_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close
#Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//cqa:Ticket'].attributes['statusStateCode'] == 'ACCEPTED_BY_ABS'
    puts 'Покупка валюты. Маршрут работает'
  else
    puts 'Покупка валюты. Маршрут не работает'.red
  end
end

################################################################################################################################################

if route['CurrSell']
# Маршрут Продажи валюты
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\CurrSell_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\fact\CurrSell_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР
  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
  client.publish('/queue/nordea_in', request) #Кидаем запрос в очередь
  sleep 10
  client.subscribe('/queue/nordea_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close
#Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//cqa:Ticket'].attributes['statusStateCode'] == 'ACCEPTED_BY_ABS'
    puts 'Продажа валюты. Маршрут работает'
  else
    puts 'Продажа валюты. Маршрут не работает'.red
  end
end

################################################################################################################################################

if route['CurrConv']
# Маршрут Конверсии валюты
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\CurrConv_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\fact\CurrConv_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР
  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
  client.publish('/queue/nordea_in', request) #Кидаем запрос в очередь
  sleep 10
  client.subscribe('/queue/nordea_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close
#Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//cqa:Ticket'].attributes['statusStateCode'] == 'ACCEPTED_BY_ABS'
    puts 'Конвертация валюты. Маршрут работает'
  else
    puts 'Конвертация валюты. Маршрут не работает'.red
  end
end

################################################################################################################################################

if route['MandatorySaleBox']
# Маршрут Перевод с транзитного счета
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\MandatorySaleBox_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\fact\MandatorySaleBox_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
  client.publish('/queue/nordea_in', request) #Кидаем запрос в очередь
  sleep 10
  client.subscribe('/queue/nordea_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close
#Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//cqa:Ticket'].attributes['statusStateCode'] == 'ACCEPTED_BY_ABS'
    puts 'Перевод с транзитного счета. Маршрут работает'
  else
    puts 'Перевод с транзитного счета. Маршрут не работает'.red
  end
end

################################################################################################################################################

if route['DocIds']
# Маршрут квитовки
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\DocIds_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\fact\DocIds_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
  client.publish('/queue/nordea_in', request) #Кидаем запрос в очередь
  sleep 10
  client.subscribe('/queue/nordea_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close
#Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//cqa:Ticket'].attributes['statusStateCode'] == 'ACCEPTED_BY_ABS'
    puts 'Квитование. Маршрут работает'
  else
    puts 'Квитование. Маршрут не работает'.red
  end
end

################################################################################################################################################

if route['StatementRequest']
# Маршрут Запрос выписки
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\StatementRequest_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\fact\StatementRequest_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
  client.publish('/queue/nordea_in', request) #Кидаем запрос в очередь
  sleep 10
  client.subscribe('/queue/nordea_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close
#Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//cqa:Ticket'].attributes['statusStateCode'] == 'ACCEPTED'
    puts 'Запрос выписки из ДБО. Маршрут работает'
  else
    puts 'Запрос выписки из ДБО. Маршрут не работает'.red
  end
end

################################################################################################################################################

if route['NotifyStmReady']
# Маршрут Формирование выписки
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\BSSCQS_NotifyStmReady_request.xml' #Путь к файлу с запросом
  response_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\BSSCQS_NotifyStmReady_response.xml'
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\fact\BSSCQS_NotifyStmReady_response_fact.xml'
  soap_request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к Веб сервису ТИР
  soap_client = Savon.client do
    endpoint 'http://vm-corint:3333/httpadapter'
    namespace 'http://WSCFT_Dispatcher.ws.nordea.ru'
  end
  soap_client.call(:do_cft_dispatcher, xml: soap_request) #Кидаем запрос в ТИР
  puts 'Запрос о готовности выписки от АБС отправлен'
  sleep 10
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
  client.subscribe('/queue/STMNotificeBath_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close
#Сравниваем эталонный ответ с фактическим
  file_etalon = File.open(response_path){ |file| file.read }
  file_fact = File.open(response_fact_path){ |file| file.read }
#xml = Document.new(file_fact)
  if file_etalon == file_fact
    puts 'Перенос выписки. Маршрут работает'
  else
    puts 'Перенос выписки. Маршрут не работает'.red
  end
end

################################################################################################################################################

if route['NotifyStmReady940']
# Маршрут Формирование выписки МТ940
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\BSSCQS_NotifyStmReady940_request.xml' #Путь к файлу с запросом
  response_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\BSSCQS_NotifyStmReady940_response.xml'
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\fact\BSSCQS_NotifyStmReady940_response_fact.xml'
  soap_request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к Веб сервису ТИР
  soap_client = Savon.client do
    endpoint 'http://vm-corint:3333/httpadapter'
    namespace 'http://WSCFT_Dispatcher.ws.nordea.ru'
  end
  soap_client.call(:do_cft_dispatcher, xml: soap_request) #Кидаем запрос в ТИР
  puts 'Запрос о готовности выписки МТ940 от АБС отправлен'
  sleep 10
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
  client.subscribe('/queue/STMNotificeBath_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close
#Сравниваем эталонный ответ с фактическим
  file_etalon = File.open(response_path){ |file| file.read }
  file_fact = File.open(response_fact_path){ |file| file.read }
#xml = Document.new(file_fact)
  if file_etalon == file_fact
    puts 'Перенос выписки МТ940. Маршрут работает'
  else
    puts 'Перенос выписки МТ940. Маршрут не работает'.red
  end
end

################################################################################################################################################

if route['NotifyStmReadyClient']
# Маршрут Формирование выписки Client(?)
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\BSSCQS_NotifyStmReadyClient_request.xml' #Путь к файлу с запросом
  response_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\BSSCQS_NotifyStmReadyClient_response.xml'
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\fact\BSSCQS_NotifyStmReadyClient_response_fact.xml'
  soap_request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к Веб сервису ТИР
  soap_client = Savon.client do
    endpoint 'http://vm-corint:3333/httpadapter'
    namespace 'http://WSCFT_Dispatcher.ws.nordea.ru'
  end
  soap_client.call(:do_cft_dispatcher, xml: soap_request) #Кидаем запрос в ТИР
  puts 'Запрос о готовности выписки Client(?) от АБС отправлен'
  sleep 10
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
  client.subscribe('/queue/nordea_out'){|msg| puts 'Найдено сообщение с выпиской в nordea_out' if msg.body.to_s}
  client.join(1)
  client.subscribe('/queue/STMNotificeBath_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close
#Сравниваем эталонный ответ с фактическим
  file_etalon = File.open(response_path){ |file| file.read }
  file_fact = File.open(response_fact_path){ |file| file.read }
#xml = Document.new(file_fact)
  if file_etalon == file_fact
    puts 'Перенос выписки Client(?). Маршрут работает'
  else
    puts 'Перенос выписки Client(?). Маршрут не работает'.red
  end
end

################################################################################################################################################

if route['CancelRequest']
# Маршрут Отзыва документа
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\CancelRequest_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\fact\CancelRequest_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР
  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
  client.publish('/queue/nordea_in', request) #Кидаем запрос в очередь
  sleep 10
  client.subscribe('/queue/nordea_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close
#Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//cqa:Ticket'].attributes['statusStateCode'] == 'PROCESSED'
    puts 'Отзыв документа. Маршрут работает'
  else
    puts 'Отзыв документа. Маршрут не работает'.red
  end
end
################################################################################################################################################

if route['NotifyClientChanged']
  # Импорт клиентов
  #Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\BSSCQS_NotifyClientChanged_request.xml' #Путь к файлу с запросом
  response_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\BSSCQS_NotifyClientChanged_response.xml'
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\fact\BSSCQS_NotifyClientChanged_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР
  soap_request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к Веб сервису ТИР
  soap_client = Savon.client do
    endpoint 'http://vm-corint:3333/httpadapter'
    namespace 'http://WSCFT_Dispatcher.ws.nordea.ru'
  end
  soap_client.call(:do_cft_dispatcher, xml: soap_request) #Кидаем запрос в ТИР
  sleep 10
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
  client.subscribe('/queue/CqsClientChanged_Q'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close
#Сравниваем эталонный ответ с фактическим
  file_etalon = File.open(response_path){ |file| file.read }
  file_fact = File.open(response_fact_path){ |file| file.read }
#xml = Document.new(file_fact)
  if file_etalon == file_fact
    puts 'Импорт клиентов. Маршрут работает'
  else
    puts 'Импорт клиентов. Маршрут не работает'.red
  end
end
################################################################################################################################################

if route['Checks']
  # Чек на Импорт клиентов
  #Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\ClDataChecksRoute_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\fact\ClDataChecksRoute_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР
  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
  client.publish('/queue/nordea_in', request) #Кидаем запрос в очередь
  sleep 10
  client.subscribe('/queue/nordea_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close
#Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.root.attributes['requestId'] == '2CFD4495-0F86-02C2-E053-0A0A1511A13C'
    puts 'Ответ на запрос импорта клиентов. Маршрут работает'
  else
    puts 'Ответ на запрос импорта клиентов. Маршрут не работает'.red
  end
end

################################################################################################################################################

if route['NotifyOrgDataMT940']
  # Импорт внешних счетов
  #Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\BSSCQS_NotifyOrgDataMT940_request.xml' #Путь к файлу с запросом
  response_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\BSSCQS_NotifyOrgDataMT940_response.xml'
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\fact\BSSCQS_NotifyOrgDataMT940_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР
  soap_request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к Веб сервису ТИР
  soap_client = Savon.client do
    endpoint 'http://vm-corint:3333/httpadapter'
    namespace 'http://WSCFT_Dispatcher.ws.nordea.ru'
  end
  soap_client.call(:do_cft_dispatcher, xml: soap_request) #Кидаем запрос в ТИР
  sleep 10
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
  client.subscribe('/queue/nordea_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close
#Сравниваем эталонный ответ с фактическим
  file_etalon = File.open(response_path){ |file| file.read }
  file_fact = File.open(response_fact_path){ |file| file.read }
#xml = Document.new(file_fact)
  if file_etalon == file_fact
    puts 'Импорт внешних счетов. Маршрут работает'
  else
    puts 'Импорт внешних счетов. Маршрут не работает'.red
  end
end
################################################################################################################################################

if route['BankDocIds']
  # Запрос статуса по инициативе банка
  #Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\BSSCQS_BankDocsIds_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\fact\BSSCQS_BankDocsIds_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР
  soap_request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к Веб сервису ТИР
  soap_client = Savon.client do
    endpoint 'http://vm-corint:3333/httpadapter'
    namespace 'http://WSCFT_Dispatcher.ws.nordea.ru'
  end
  soap_client.call(:do_cft_dispatcher, xml: soap_request) #Кидаем запрос в ТИР
  sleep 10
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
  client.subscribe('/queue/nordea_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close
#Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//abs:DocId'].attributes['docId'] == '5fd9eacb-0ae1-4528-8086-d285d5ce2931'
    puts 'Запрос статуса по инициативе банка. Маршрут работает'
  else
    puts 'Запрос статуса по инициативе банка. Маршрут не работает'.red
  end
end
################################################################################################################################################

if route['PinEnvelope']
  #ПИН-конверты
  #Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\PinEnvelope_request.xml' #Путь к файлу с запросом
  response_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\PinEnvelope_response.xml'
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\fact\PinEnvelope_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР
  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
  client.publish('/queue/nordea_in', request) #Кидаем запрос в очередь
  sleep 10
  client.subscribe('/queue/nordea_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close
#Сравниваем эталонный ответ с фактическим
  file_etalon = File.open(response_path){ |file| file.read }
  file_fact = File.open(response_fact_path){ |file| file.read }
  if file_etalon == file_fact
    puts 'ПИН-конверты. Маршрут работает'
  else
    puts 'ПИН-конверты. Маршрут не работает'.red
  end
end

################################################################################################################################################

if route['ReviseRequest']
  # Запрос отчета о сверке
  #Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\BSSCQS_ReviseRequest_request.xml' #Путь к файлу с запросом
  response_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\BSSCQS_ReviseRequest_response.xml'
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\fact\BSSCQS_ReviseRequest_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР
  soap_request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к Веб сервису ТИР
  soap_client = Savon.client do
    endpoint 'http://vm-corint:3333/httpadapter'
    namespace 'http://WSCFT_Dispatcher.ws.nordea.ru'
  end
  soap_client.call(:do_cft_dispatcher, xml: soap_request) #Кидаем запрос в ТИР
  sleep 10
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
  client.subscribe('/queue/CqsReviseRequest_Q'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close
#Сравниваем эталонный ответ с фактическим
  file_etalon = File.open(response_path){ |file| file.read }
  file_fact = File.open(response_fact_path){ |file| file.read }
  if file_etalon == file_fact
    puts 'Запрос отчета о сверке. Маршрут работает'
  else
    puts 'Запрос отчета о сверке. Маршрут не работает'.red
  end
end
################################################################################################################################################

if route['ReviseResponse']
#Перенос отчета о сверке
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\ReviseResponse_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20_Nordea\fact\ReviseResponse_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР
  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
  client.publish('/queue/nordea_in', request) #Кидаем запрос в очередь
  sleep 10
  client.subscribe('/queue/nordea_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close
#Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.root.attributes['requestId'] == '3640A4F3-C8D8-01D6-E053-0A0A15110DE9'
    puts 'Перенос отчета о сверке. Маршрут работает'
  else
    puts 'Перенос отчета о сверке. Маршрут не работает'.red
  end
end
puts "Закончили прогон автотестов в #{Time.now}"
################################################################################################################################################