#coding: utf-8
require 'stomp'
require 'savon'
require 'colorize'
require 'rexml/document'
require 'securerandom'
include REXML

route = {
    'PayDocRu'          =>    true,
    'DocIds'            =>    true,
    'CancelRequest'     =>    true,
    'StatementRequest'  =>    true,
    'SysStatementRequest' =>  true,
    'PayDocCur'         =>    true,
    'CurrBuy'           =>    true,
    'CurrSell'          =>    true,
    'CurrConv'          =>    true,
    'MandatorySaleBox'  =>    true,
    'DealPassCred138I'  =>    true,
    'DealPassCon138I'   =>    true,
    'CurrDealCertificate138I' => true,
    'ConfDocCertificate138I'  => true}

# Очищаем очередь
client = Stomp::Client.new('admin', 'admin', 'vm-opentir', 61613)
client.subscribe('/queue/tir_vmopen_out'){|msg| puts 'Очередь tir_vmopen_out очищена' if msg.body.to_s}
client.join(1)
#client.subscribe('/queue/tir_vmopenVK_out'){|msg| puts 'Очередь tir_vmopenVK_out очищена' if msg.body.to_s}
#client.join(1)
#client.subscribe('/queue/STMNotificeBath_out'){|msg| puts 'Очередь STMNotificeBath_out очищена' if msg.body.to_s}
#client.join(1)
client.close

################################################################################################################################################
puts "Запустили автотесты маршрутов в #{Time.now}"
# Маршрут РПП
if route['PayDocRu']
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\PayDocRu_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\fact\PayDocRu_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint2', 61613)
  client.publish('/queue/correqts230_in', request) #Кидаем запрос в очередь
  sleep 5
  client.subscribe('/queue/tir_vmopen_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close

#Отключаемся от MQ
  file_fact.close

#Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//p:Ticket'].attributes['statusStateCode'] == 'ACCEPTED_BY_ABS' # && request.elements['/hmbo:PayDocRu'].attributes['docId']== file_fact.elements['//p:Ticket'].attributes['docId']
    puts 'РПП. Маршрут работает'
  else
    puts 'РПП. Маршрут не работает'.red
  end
end

# Маршрут квитовки
if route['DocIds']
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\DocIds_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\fact\DocIds_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')

#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint2', 61613)
  client.publish('/queue/correqts230_in', request) #Кидаем запрос в очередь
  sleep 5
  client.subscribe('/queue/tir_vmopen_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close

#Отключаемся от MQ
  file_fact.close

#Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//p:Ticket'].attributes['statusStateCode'] == 'PROCESSED'
    puts 'Квитование. Маршрут работает'
  else
    puts 'Квитование. Маршрут не работает'.red
  end
end

# Маршрут запроса на отзыв
if route['CancelRequest']
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\CancelRequest_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\fact\CancelRequest_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')

#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint2', 61613)
  client.publish('/queue/correqts230_in', request)  #Кидаем запрос в очередь
  sleep 5
  client.subscribe('/queue/tir_vmopen_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close

#Отключаемся от MQ
  file_fact.close

#Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//p:Ticket'].attributes['statusStateCode'] == 'PROCESSED' and file_fact.elements['//p:Ticket'].attributes['docType'] == 'CancelRequest'
    puts 'Запрос на отзыв. Маршрут работает'
  else
    puts 'Запрос на отзыв. Маршрут не работает'.red
  end
end

# Маршрут пользовательский запрос выписки
if route['StatementRequest']
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\StatementRequest_request.xml' #Путь к файлу с запросом
  response_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\StatementRequest_response.xml' #Путь к файлу с ответом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\fact\StatementRequest_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint2', 61613)
  client.publish('/queue/correqts230_in', request)  #Кидаем запрос в очередь
  sleep 5
  client.subscribe('/queue/tir_vmopen_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close

#Сравниваем эталонный ответ с фактическим
  file_etalon = Document.new(File.open(response_path){ |file| file.read })
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_etalon.elements['//res:Statement'].attributes['creditSum'] == file_fact.elements['//res:Statement'].attributes['creditSum'] &&
      file_etalon.elements['////res:TransInfo'].attributes['docCurr'] == file_fact.elements['/////res:TransInfo'].attributes['docCurr'] &&
      file_etalon.elements['/////res:DepartmentalInfo'].attributes['docNo'] == file_fact.elements['/////res:DepartmentalInfo'].attributes['docNo']
    puts 'Выписка. Маршрут работает'
  else
    puts 'Выписка. Маршрут не работает'.red
  end
end

#Маршрут системный запрос выписки
if route['StatementRequest']
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\SysStmtRequest_request.xml' #Путь к файлу с запросом
  response_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\SysStmtRequest_response.xml' #Путь к файлу с ответом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\fact\SysStmtRequest_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint2', 61613)
  client.publish('/queue/correqts230_in', request)  #Кидаем запрос в очередь
  sleep 5
  client.subscribe('/queue/tir_vmopen_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close

#Сравниваем эталонный ответ с фактическим
  file_etalon = Document.new(File.open(response_path){ |file| file.read })
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_etalon.elements['//res:Statement'].attributes['creditSum'] == file_fact.elements['//res:Statement'].attributes['creditSum'] &&
      file_etalon.elements['////res:TransInfo'].attributes['docCurr'] == file_fact.elements['/////res:TransInfo'].attributes['docCurr'] &&
      file_etalon.elements['/////res:DepartmentalInfo'].attributes['docNo'] == file_fact.elements['/////res:DepartmentalInfo'].attributes['docNo']
    puts 'Системная выписка. Маршрут работает'
  else
    puts 'Системная выписка. Маршрут не работает'.red
  end
end


# Маршрут перевод валюты
if route['PayDocCur']
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\PayDocCur_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\fact\PayDocCur_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')

#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint2', 61613)
  client.publish('/queue/correqts230_in', request)  #Кидаем запрос в очередь
  sleep 5
  client.subscribe('/queue/tir_vmopen_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close

#Отключаемся от MQ
  file_fact.close

#Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//p:Ticket'].attributes['statusStateCode'] == 'ACCEPTED_BY_ABS' and file_fact.elements['//p:Ticket'].attributes['docType'] == 'PayDocCur'
    puts 'Перевод валюты. Маршрут работает'
  else
    puts 'Перевод валюты. Маршрут не работает'.red
  end
end

#Маршрут покупка валюты
if route['CurrBuy']
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\CurrBuy_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\fact\CurrBuy_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')

#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint2', 61613)
  client.publish('/queue/correqts230_in', request)  #Кидаем запрос в очередь
  sleep 5
  client.subscribe('/queue/tir_vmopen_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close

#Отключаемся от MQ
  file_fact.close

#Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//p:Ticket'].attributes['statusStateCode'] == 'ACCEPTED_BY_ABS' and file_fact.elements['//p:Ticket'].attributes['docType'] == 'CurrBuy'
    puts 'Покупка валюты. Маршрут работает'
  else
    puts 'Покупка валюты. Маршрут не работает'.red
  end
end

#Маршрут продажа валюты
if route['CurrSell']
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\CurrSell_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\fact\CurrSell_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')

#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint2', 61613)
  client.publish('/queue/correqts230_in', request)  #Кидаем запрос в очередь
  sleep 5
  client.subscribe('/queue/tir_vmopen_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close

#Отключаемся от MQ
  file_fact.close

#Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//p:Ticket'].attributes['statusStateCode'] == 'ACCEPTED_BY_ABS' and file_fact.elements['//p:Ticket'].attributes['docType'] == 'CurrSell'
    puts 'Продажа валюты. Маршрут работает'
  else
    puts 'Продажа валюты. Маршрут не работает'.red
  end
end

#Маршрут конверсия валюты
if route['CurrConv']
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\CurrConv_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\fact\CurrConv_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')

#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint2', 61613)
  client.publish('/queue/correqts230_in', request)  #Кидаем запрос в очередь
  sleep 5
  client.subscribe('/queue/tir_vmopen_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close

#Отключаемся от MQ
  file_fact.close

#Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//p:Ticket'].attributes['statusStateCode'] == 'ACCEPTED_BY_ABS' and file_fact.elements['//p:Ticket'].attributes['docType'] == 'CurrConv'
    puts 'Конверсия валюты. Маршрут работает'
  else
    puts 'Конверсия валюты. Маршрут не работает'.red
  end
end

#Маршрут перевод с транзитного счета
if route['MandatorySaleBox']
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\MandatorySaleBox_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\fact\MandatorySaleBox_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')

#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint2', 61613)
  client.publish('/queue/correqts230_in', request)  #Кидаем запрос в очередь
  sleep 5
  client.subscribe('/queue/tir_vmopen_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close

#Отключаемся от MQ
  file_fact.close

#Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//p:Ticket'].attributes['statusStateCode'] == 'ACCEPTED_BY_ABS' and file_fact.elements['//p:Ticket'].attributes['docType'] == 'MandatorySaleBox'
    puts 'Перевод с транзитного счета. Маршрут работает'
  else
    puts 'Перевод с транзитного счета. Маршрут не работает'.red
  end
end

#Маршрут ПСпоКД(Паспорт Сделки по Кредитным Договорам)
if route['DealPassCred138I']
  #Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\DealPassCred138I_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\fact\DealPassCred138I_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

  file_fact = File.open(response_fact_path, 'w')

  #### Закидываем в буфер xml-ку и генерим для неё новый ID
  xmlfile = File.open(request_path.to_s){ |file| file.read }
  def make_message(file, message)
    file.each_line do |line|
      line.gsub!("c3618e16-d7da-4bf7-9a8d-1da75589fb3e",SecureRandom.uuid)
      message << line
    end
    return message
  end
  make_message(xmlfile, message = String.new)


  #Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint2', 61613)
  client.publish('/queue/correqts230_in', message)  #Кидаем запрос в очередь
  sleep 5
  client.subscribe('/queue/tir_vmopenVK_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close

  #Отключаемся от MQ
  file_fact.close

  #Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//p:Ticket'].attributes['statusStateCode'] == 'REFUSED_BY_CFE' and file_fact.elements['//p:Ticket'].attributes['docType'] == 'DealPassCred138I'
    puts 'ПСпоКД. Маршрут работает'
  else
    puts 'ПСпоКД. Маршрут не работает'.red
  end
end

#Маршрут ПСпК(Паспорт Сделки по Контрактам)
if route['DealPassCon138I']
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\DealPassCon138I_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\fact\DealPassCon138I_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

  file_fact = File.open(response_fact_path, 'w')

  #### Закидываем в буфер xml-ку и генерим для неё новый ID
  xmlfile = File.open(request_path.to_s){ |file| file.read }
  def make_message(file, message)
    file.each_line do |line|
      line.gsub!("c3618e16-d7da-4bf7-9a8d-1da75589fb3e",SecureRandom.uuid)
      message << line
    end
    return message
  end
  make_message(xmlfile, message = String.new)


  #Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint2', 61613)
  client.publish('/queue/correqts230_in', message)  #Кидаем запрос в очередь
  sleep 5
  client.subscribe('/queue/tir_vmopenVK_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close

  #Отключаемся от MQ
  file_fact.close

  #Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//p:Ticket'].attributes['statusStateCode'] == 'REFUSED_BY_CFE' and file_fact.elements['//p:Ticket'].attributes['docType'] == 'DealPassCon138I'
    puts 'ПСпК. Маршрут работает'
  else
    puts 'ПСпК. Маршрут не работает'.red
  end
end

#Маршрут СВО(Справка по валютным операциям)
if route['CurrDealCertificate138I']
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\CurrDealCertificate138I_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\fact\CurrDealCertificate138I_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

  file_fact = File.open(response_fact_path, 'w')

  #### Закидываем в буфер xml-ку и генерим для неё новый ID
  xmlfile = File.open(request_path.to_s){ |file| file.read }
  def make_message(file, message)
    file.each_line do |line|
      line.gsub!("c3618e16-d7da-4bf7-9a8d-1da75589fb3e",SecureRandom.uuid)
      message << line
    end
    return message
  end
  make_message(xmlfile, message = String.new)


  #Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint2', 61613)
  client.publish('/queue/correqts230_in', message)  #Кидаем запрос в очередь
  sleep 5
  client.subscribe('/queue/tir_vmopenVK_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close

  #Отключаемся от MQ
  file_fact.close

  #Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//p:Ticket'].attributes['statusStateCode'] == 'REFUSED_BY_CFE' and file_fact.elements['//p:Ticket'].attributes['docType'] == 'CurrDealCertificate138I'
    puts 'СВО. Маршрут работает'
  else
    puts 'СВО. Маршрут не работает'.red
  end
end

#Маршрут СПД(Справка по договорам)
if route['ConfDocCertificate138I']
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\ConfDocCertificate138I_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-IBSO(Open)\fact\ConfDocCertificate138I_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

  file_fact = File.open(response_fact_path, 'w')

  #### Закидываем в буфер xml-ку и генерим для неё новый ID
  xmlfile = File.open(request_path.to_s){ |file| file.read }
  def make_message(file, message)
    file.each_line do |line|
      line.gsub!("c3618e16-d7da-4bf7-9a8d-1da75589fb3e",SecureRandom.uuid)
      message << line
    end
    return message
  end
  make_message(xmlfile, message = String.new)


  #Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint2', 61613)
  client.publish('/queue/correqts230_in', message)  #Кидаем запрос в очередь
  sleep 5
  client.subscribe('/queue/tir_vmopenVK_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close

  #Отключаемся от MQ
  file_fact.close

  #Сравниваем эталонный ответ с фактическим
  file_fact = Document.new(File.open(response_fact_path){ |file| file.read })
  if file_fact.elements['//p:Ticket'].attributes['statusStateCode'] == 'REFUSED_BY_CFE' and file_fact.elements['//p:Ticket'].attributes['docType'] == 'ConfDocCertificate138I'
    puts 'СПД. Маршрут работает'
  else
    puts 'СПД. Маршрут не работает'.red
  end
end