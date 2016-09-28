#coding: utf-8
require 'stomp'
require 'colorize'
require 'rexml/document'
include REXML

route = {
    'PayDocRu'          => true,
    'PayDocCur'         => true,
    'CurrBuy'           => true,
    'CurrSell'          => true,
    'CurrConv'          => true,
    'MandatorySaleBox'  => true,
    'StatementRequest'  => true,
    'TBSVK'             => true,
    'PayDocRuReestr'    => true,
    'PayRoll'           => true,
    'DocIds'            => true,
    'ClientRequest'     => true,
    'CancelRequest'     => true}



# Очищаем очередь
client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
client.subscribe('/queue/tir_inversion_auto_out'){|msg| puts 'Очередь очищена' if msg.body.to_s}
client.join(1)
client.close

################################################################################################################################################
20.times do
  if route['PayDocRu']
# Маршрут ТБСВК
#Задаем пути к файлам
    request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\PayDocRu_request.xml' #Путь к файлу с запросом
    response_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\PayDocRu_response.xml' #Путь к файлу с ответом
    response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\fact\PayDocRu_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

    request = File.open(request_path){|file| file.read}
    file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
    client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
    client.publish('/queue/correqts220_in', request) #Кидаем запрос в очередь
    sleep 10
    client.subscribe('/queue/tir_inversion_auto_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
    client.join(1)
    client.close
#Отключаемся от MQ
    file_fact.close
#Сравниваем эталонный ответ с фактическим
    file_etalon = File.open(response_path){ |file| file.read }
    file_fact = File.open(response_fact_path){ |file| file.read }
#xml = Document.new(file_fact)
    if file_etalon == file_fact
      #if xml.elements['//p:Ticket'].attributes['statusStateCode'] == 'ACCEPTED_BY_ABS'
      puts 'РПП. Маршрут работает'
    else
      puts 'РПП. Маршрут не работает'.red
    end
  end
################################################################################################################################################

  if route['PayDocCur']
# Маршрут Перевод валюты
#Задаем пути к файлам
    request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\PayDocCur_request.xml' #Путь к файлу с запросом
    response_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\PayDocCur_response.xml' #Путь к файлу с ответом
    response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\fact\PayDocCur_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

    request = File.open(request_path){|file| file.read}
    file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
    client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
    client.publish('/queue/correqts220_in', request) #Кидаем запрос в очередь
    sleep 10
    client.subscribe('/queue/tir_inversion_auto_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
    client.join(1)
    client.close
#Отключаемся от MQ
    file_fact.close
#Сравниваем эталонный ответ с фактическим
    file_etalon = File.open(response_path){ |file| file.read }
    file_fact = File.open(response_fact_path){ |file| file.read }
    if file_etalon == file_fact
      puts 'Перевод валюты. Маршрут работает'
    else
      puts 'Перевод валюты. Маршрут не работает'.red
    end
  end

################################################################################################################################################

  if route['CurrBuy']
# Маршрут ТБСВК
#Задаем пути к файлам
    request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\CurrBuy_request.xml' #Путь к файлу с запросом
    response_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\CurrBuy_response.xml' #Путь к файлу с ответом
    response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\fact\CurrBuy_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

    request = File.open(request_path){|file| file.read}
    file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
    client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
    client.publish('/queue/correqts220_in', request) #Кидаем запрос в очередь
    sleep 10
    client.subscribe('/queue/tir_inversion_auto_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
    client.join(1)
    client.close
#Отключаемся от MQ
    file_fact.close
#Сравниваем эталонный ответ с фактическим
    file_etalon = File.open(response_path){ |file| file.read }
    file_fact = File.open(response_fact_path){ |file| file.read }
    if file_etalon == file_fact
      puts 'Покупка валюты. Маршрут работает'
    else
      puts 'Покупка валюты. Маршрут не работает'.red
    end
  end

################################################################################################################################################

  if route['CurrSell']
# Маршрут ТБСВК
#Задаем пути к файлам
    request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\CurrSell_request.xml' #Путь к файлу с запросом
    response_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\CurrSell_response.xml' #Путь к файлу с ответом
    response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\fact\CurrSell_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

    request = File.open(request_path){|file| file.read}
    file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
    client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
    client.publish('/queue/correqts220_in', request) #Кидаем запрос в очередь
    sleep 10
    client.subscribe('/queue/tir_inversion_auto_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
    client.join(1)
    client.close
#Отключаемся от MQ
    file_fact.close
#Сравниваем эталонный ответ с фактическим
    file_etalon = File.open(response_path){ |file| file.read }
    file_fact = File.open(response_fact_path){ |file| file.read }
    if file_etalon == file_fact
      puts 'Продажа валюты. Маршрут работает'
    else
      puts 'Продажа валюты. Маршрут не работает'.red
    end
  end

################################################################################################################################################

  if route['CurrConv']
# Маршрут ТБСВК
#Задаем пути к файлам
    request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\CurrConv_request.xml' #Путь к файлу с запросом
    response_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\CurrConv_response.xml' #Путь к файлу с ответом
    response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\fact\CurrConv_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

    request = File.open(request_path){|file| file.read}
    file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
    client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
    client.publish('/queue/correqts220_in', request) #Кидаем запрос в очередь
    sleep 10
    client.subscribe('/queue/tir_inversion_auto_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
    client.join(1)
    client.close
#Отключаемся от MQ
    file_fact.close
#Сравниваем эталонный ответ с фактическим
    file_etalon = File.open(response_path){ |file| file.read }
    file_fact = File.open(response_fact_path){ |file| file.read }
    if file_etalon == file_fact
      puts 'Конвертация валюты. Маршрут работает'
    else
      puts 'Конвертация валюты. Маршрут не работает'.red
    end
  end

################################################################################################################################################

  if route['MandatorySaleBox']
# Маршрут ТБСВК
#Задаем пути к файлам
    request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\MandatorySaleBox_request.xml' #Путь к файлу с запросом
    response_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\MandatorySaleBox_response.xml' #Путь к файлу с ответом
    response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\fact\MandatorySaleBox_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

    request = File.open(request_path){|file| file.read}
    file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
    client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
    client.publish('/queue/correqts220_in', request) #Кидаем запрос в очередь
    sleep 10
    client.subscribe('/queue/tir_inversion_auto_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
    client.join(1)
    client.close
#Отключаемся от MQ
    file_fact.close
#Сравниваем эталонный ответ с фактическим
    file_etalon = File.open(response_path){ |file| file.read }
    file_fact = File.open(response_fact_path){ |file| file.read }
    if file_etalon == file_fact
      puts 'Перевод с транзитного счета. Маршрут работает'
    else
      puts 'Перевод с транзитного счета. Маршрут не работает'.red
    end
  end

################################################################################################################################################

  if route['StatementRequest']
# Маршрут ТБСВК
#Задаем пути к файлам
    request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\StatementRequest_request.xml' #Путь к файлу с запросом
    response_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\StatementRequest_response.xml' #Путь к файлу с ответом
    response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\fact\StatementRequest_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

    request = File.open(request_path){|file| file.read}
    file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
    client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
    client.publish('/queue/correqts220_in', request) #Кидаем запрос в очередь
    sleep 10
    client.subscribe('/queue/tir_inversion_auto_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
    client.join(1)
    client.close
#Отключаемся от MQ
    file_fact.close
#Сравниваем эталонный ответ с фактическим
    file_etalon = File.open(response_path){ |file| file.read }
    file_fact = File.open(response_fact_path){ |file| file.read }
    if file_fact.include?(file_etalon)
      puts 'Выписка. Маршрут работает'
    else
      puts 'Выписка. Маршрут не работает'.red
    end
  end

################################################################################################################################################

  if route['TBSVK']
# Маршрут ТБСВК
#Задаем пути к файлам
    request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\ReqTBSVKPS.xml' #Путь к файлу с запросом
    response_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\RespPSTBSVK.xml' #Путь к файлу с ответом
    response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\fact\RespPSTBSVK_fact.xml' #Путь к файлу с фактическим ответом из ТИР

    request = File.open(request_path){|file| file.read}
    file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
    client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
    client.publish('/queue/correqts220_in', request) #Кидаем запрос в очередь
    sleep 10
    client.subscribe('/queue/tbsvk_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
    client.join(1)
    client.close
#Отключаемся от MQ
    file_fact.close
#Сравниваем эталонный ответ с фактическим
    file_etalon = File.open(response_path){ |file| file.read }
    file_fact = File.open(response_fact_path){ |file| file.read }
    if file_etalon == file_fact
      puts 'ТБСВК. Маршрут работает'
    else
      puts 'ТБСВК. Маршрут не работает'.red
    end
  end

################################################################################################################################################

  if route['PayDocRuReestr']
# Маршрут ТБСВК
#Задаем пути к файлам
    request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\PayDocRuReestr_request.xml' #Путь к файлу с запросом
    response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\fact\PayDocRuReestr_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

    request = File.open(request_path){|file| file.read}
    file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
    client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
    client.publish('/queue/correqts220_in', request) #Кидаем запрос в очередь
    sleep 10
    client.subscribe('/queue/tir_inversion_auto_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
    client.join(1)
    client.close
#Отключаемся от MQ
    file_fact.close
#Сравниваем эталонный ответ с фактическим
    file_fact = File.open(response_fact_path){ |file| file.read }
    xml = Document.new(file_fact)
    if xml.elements['//p:Ticket'].attributes['statusStateCode'] == 'ACCEPTED_BY_ABS'
      puts 'Реестр. Маршрут работает'
    else
      puts 'Реестр. Маршрут не работает'.red
    end
  end

################################################################################################################################################

  if route['PayRoll']
# Маршрут ТБСВК
#Задаем пути к файлам
    request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\PayRoll_request.xml' #Путь к файлу с запросом
    response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\fact\PayRoll_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

    request = File.open(request_path){|file| file.read}
    file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
    client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
    client.publish('/queue/correqts220_in', request) #Кидаем запрос в очередь
    sleep 10
    client.subscribe('/queue/tir_inversion_auto_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
    client.join(1)
    client.close
#Отключаемся от MQ
    file_fact.close
#Сравниваем эталонный ответ с фактическим
    file_fact = File.open(response_fact_path){ |file| file.read }
    xml = Document.new(file_fact)
    if xml.elements['//p:Ticket'].attributes['statusStateCode'] == 'ACCEPTED_BY_ABS'
      puts 'Зарплатная ведомость. Маршрут работает'
    else
      puts 'Зарплатная ведомость. Маршрут не работает'.red
    end
  end

################################################################################################################################################

  if route['DocIds']
# Маршрут ТБСВК
#Задаем пути к файлам
    request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\DocIds_request.xml' #Путь к файлу с запросом
    response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\fact\DocIds_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

    request = File.open(request_path){|file| file.read}
    file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
    client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
    client.publish('/queue/correqts220_in', request) #Кидаем запрос в очередь
    sleep 10
    client.subscribe('/queue/tir_inversion_auto_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
    client.join(1)
    client.close
#Отключаемся от MQ
    file_fact.close
#Сравниваем эталонный ответ с фактическим
    file_fact = File.open(response_fact_path){ |file| file.read }
    xml = Document.new(file_fact)
    if xml.elements['//p:Ticket'].attributes['statusStateCode'] == 'DELAYED'
      puts 'Квитование. Маршрут работает'
    else
      puts 'Квитование. Маршрут не работает'.red
    end
  end

################################################################################################################################################

  if route['ClientRequest']
# Маршрут ТБСВК
#Задаем пути к файлам
    request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\ClientRequest_request.xml' #Путь к файлу с запросом
    response_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\ClientRequest_response.xml' #Путь к файлу с ответом
    response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\fact\ClientRequest_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

    request = File.open(request_path){|file| file.read}
    file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
    client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
    client.publish('/queue/correqts220_in', request) #Кидаем запрос в очередь
    sleep 10
    client.subscribe('/queue/tir_inversion_auto_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
    client.join(1)
    client.close
#Отключаемся от MQ
    file_fact.close
#Сравниваем эталонный ответ с фактическим
    file_etalon = File.open(response_path){ |file| file.read }
    file_fact = File.open(response_fact_path){ |file| file.read }
    if file_fact.include?(file_etalon)
      puts 'Импорт клиентов. Маршрут работает'
    else
      puts 'Импорт клиентов. Маршрут не работает'.red
    end
  end

  end
################################################################################################################################################

if route['CancelRequest']
# Маршрут ТБСВК
#Задаем пути к файлам
  request_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\CancelRequest_request.xml' #Путь к файлу с запросом
  response_fact_path = '\\\\vm-corint\TIR\ETALON_XML\TIR20-InversionXXI_KBE\fact\CancelRequest_response_fact.xml' #Путь к файлу с фактическим ответом из ТИР

  request = File.open(request_path){|file| file.read}
  file_fact = File.open(response_fact_path, 'w')
#Подключаемся к MQ
  client = Stomp::Client.new('admin', 'admin', 'vm-corint', 61613)
  client.publish('/queue/correqts220_in', request) #Кидаем запрос в очередь
  sleep 10
  client.subscribe('/queue/tir_inversion_auto_out'){|msg| file_fact.write msg.body.to_s} #Считываем ответ в файл
  client.join(1)
  client.close
#Отключаемся от MQ
  file_fact.close
#Сравниваем эталонный ответ с фактическим
  file_fact = File.open(response_fact_path){ |file| file.read }
  xml = Document.new(file_fact)
  if xml.elements['//p:Ticket'].attributes['statusStateCode'] == 'PROCESSED'
    puts 'Отзыв документа. Маршрут работает'
  else
    puts 'Отзыв документа. Маршрут не работает'.red
  end
end
################################################################################################################################################