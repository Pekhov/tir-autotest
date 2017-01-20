#coding: utf-8
require 'stomp'
require 'securerandom'
require 'rexml/document'
include REXML
require 'logger'
require 'colorize'
require 'yaml'
require 'savon'

log = Logger.new(File.open('log.txt', 'w'))
component = {
    "Stored procedure"  => true,
    "ActiveMq"          => true,
    "FileAdapter"       => true,
    "HTTP_Adapter"      => true}

#Данные по стенду

log << config = YAML::load_file('.\config.conf')
server =  config['TIR Active MQ host']
port =    config['TIR Active MQ port']
inputqueue =   config['TIR Входящая очередь']
outputqueue= config['TIR Исходящая очередь']
login =   config['TIR Active MQ login']
password= config['TIR Active MQ password']
route_DBAdapter = config['Маршрут проверки Хранимых процедур']
activeMQlistner = config['Маршрут проверки Слушающего компонента']
answer_BS_R_STM_ABS_A = config['Маршрут ответа АБС слушающего компонента']
fileadapter = config['Маршрут проверки Файлового адаптера']
http_adapter = config['Маршрут проверки HTTP адаптера']
http_adapter_server = config['TIR HTTP Adapter']

begin
# Очищаем очередь
client = Stomp::Client.new(login, password, server, port)
client.subscribe(outputqueue){|msg| puts = "Очередь #{outputqueue} очищена" if msg.body.to_s}
client.join(1)
client.subscribe('/queue/test_activemq_out'){|msg| puts  = "Очередь '/queue/test_activemq_out' очищена" if msg.body.to_s}
client.join(1)
client.close
responseFromTIR = String.new
requestFromTIR = String.new

puts text = "Запустили автотесты маршрутов в #{Time.now}\n"
log.info(text)

log.info("################################################################################################################################################")

  if component["Stored procedure"]
    log.info("-= Проверка компонента Хранимых процедур =-")
    request = File.open(route_DBAdapter){|file| file.read}
    client = Stomp::Client.new(login, password, server, port)
    client.publish(inputqueue, request)
    log.info("Отправили сообщение в ТИР:\n")
    log << request
    sleep 5
    client.subscribe(outputqueue){|msg| responseFromTIR << msg.body.to_s}
    client.join(3)
    log.info("Приняли ответ от ТИР:\n")
    log << responseFromTIR + "\n"
    client.close

    responseFromTIRtoXML = Document.new(responseFromTIR)
    if responseFromTIRtoXML.elements['//p:Ticket'].attributes['statusStateCode'] == 'ACCEPTED_BY_ABS'
    puts text = "Адаптер Active MQ работает\nКомпонент трансформации работает\nКомпонент взаимодействия с БД работает"
    else puts text =  "Проверка компонента взаимодействия с БД провалилась!".red
    end
    log.info(text)
    responseFromTIR.clear
    responseFromTIRtoXML = String.new
  end
log.info("################################################################################################################################################")
    if component["ActiveMq"]
        log.info("-= Проверка Слушающего компонента Active MQ =-")
        request = File.open(activeMQlistner){|file| file.read}

        client = Stomp::Client.new(login, password, server, port)
        client.publish(inputqueue, request, headers = {'correlation-id'=>SecureRandom.uuid})
        log.info("Отправили сообщение в ТИР:\n")
        log << request + "\n"
        sleep 5
        client.subscribe('/queue/test_activemq_out'){|msg| requestFromTIR << msg.body.to_s}
        client.join(3)
        log.info("Приняли ответ от ТИР:\n")
        log << requestFromTIR + "\n"
        if request.length > 0
            requestFromTIRtoXML = Document.new(requestFromTIR)
            answer = Document.new(File.open(answer_BS_R_STM_ABS_A){ |file| file.read })
            answer.elements['//ns1:BSMessage'].attributes['ID'] = requestFromTIRtoXML.elements['//ns0:BSMessage'].attributes['ID']
            client.publish('/queue/szvABS_out', answer.to_s) #Кидаем запрос в очередь
            log.info("Отправили сообщение от АБС в ТИР:\n")
            log << answer.to_s + "\n"
            if answer.elements['//ns1:BSMessage'].attributes['ID'] == ''
                puts text = "[#{Time.now}] Обработали запрос #{requestFromTIRtoXML.elements['//ns0:BSMessage'].attributes['xmlns:ns0']} из очереди szvABS_in с пустым ID, видимо, не заполнен Correlation ID в запросе"
            else
                puts text = "[#{Time.now}] Обработали запрос #{requestFromTIRtoXML.elements['//ns0:BSMessage'].attributes['xmlns:ns0']} из очереди szvABS_in с ID = #{requestFromTIRtoXML.elements['//ns0:BSMessage'].attributes['ID']}"
            end
            log.info(text)
        end
        client.subscribe(outputqueue){|msg| responseFromTIR << msg.body.to_s}
        client.join(3)
        log.info("Приняли ответ от ТИР:\n")
        log << responseFromTIR + "\n"
        client.close
        responseFromTIRtoXML = Document.new(responseFromTIR)
        if responseFromTIRtoXML.elements['//state'].text == 'ACCEPTED_BY_ABS'
            puts text = "Слушающий компонент ActiveMQ работает"
        else puts text = "Проверка компонента слушающего компонента ActiveMQ провалилась!".red
        end
        log.info(text)
        responseFromTIR.clear
        responseFromTIRtoXML = String.new
        end
log.info("################################################################################################################################################")
if component["FileAdapter"]
    log.info("-= Проверка Файлового Адаптера и компонента =-")
    request = File.open(fileadapter){|file| file.read}
    client = Stomp::Client.new(login, password, server, port)
    client.publish(inputqueue, request)
    log.info("Отправили сообщение в ТИР:\n")
    log << request
    sleep 2
    responseOmega = <<EOF
<?xml version="1.0" encoding="windows-1251" standalone="yes" ?>
<BODY Type="STATUS_CURRBUY">
<DOCREF DataType="STRING">5726C254143147F194D6246D28A8EDCB</DOCREF>
<STATUS DataType="INTEGER">17041</STATUS>
<VALUEDATE DataType="DATE"></VALUEDATE>
<NOTEFROMBANK DataType="STRING">note from bank</NOTEFROMBANK>
<RECEIVEROFFICIALS DataType="STRING">Иванов Иван Алексеевич</RECEIVEROFFICIALS>
</BODY>
EOF
    File.open('\\\\vm-corint\Gates\Omega\in_status_autotest\STATUS_CURRBUY_160420091010.xml', 'w'){ |file| file.write responseOmega }
    log.info("Подложили файл со статусом в каталог ТИРа:\n")
    log << responseOmega + "\n"
    sleep 10
    client.subscribe(outputqueue){|msg| responseFromTIR << msg.body.to_s}
    client.join(3)
    log.info("Приняли ответ от ТИР:\n")
    log << responseFromTIR + "\n"
    client.close

    responseFromTIRtoXML = Document.new(responseFromTIR)
    if responseFromTIRtoXML.elements['//p:Ticket'].attributes['statusStateCode'] == 'PROCESSED'
        puts text = "Файловый компонент работает\nФайловый адаптер работает"
    else puts text =  "Проверка файлового компонента провалилась!".red
    end
    log.info(text)
    responseFromTIR.clear
    responseFromTIRtoXML = String.new
end

log.info("################################################################################################################################################")
if component["HTTP_Adapter"]
  log.info("-= Проверка HTTP Адаптера =-")
  request = File.open(http_adapter){|file| file.read}
  #Подключаемся к Веб сервису ТИР
  soap_client = Savon.client do
    endpoint http_adapter_server
    namespace 'http://WSCFT_Dispatcher.ws.nordea.ru'
  end
  soap_client.call(:do_cft_dispatcher, xml: request) #Кидаем запрос в ТИР
  log.info("Отправили soap запрос в HTTP адаптер ТИР:\n")
  log << request + "\n"
  sleep 5
  client = Stomp::Client.new(login, password, server, port)
  client.subscribe(outputqueue){|msg| responseFromTIR << msg.body.to_s}
  client.join(3)
  log.info("Приняли ответ от ТИР:\n")
  log << responseFromTIR + "\n"
  client.close
  responseFromTIRtoXML = Document.new(responseFromTIR)
  if responseFromTIRtoXML.elements['//ShortName'].text == 'ООО "ЛАНТЕР"'
    puts text = "HTTP адаптер работает"
  else puts text = "HTTP адаптер не работает!".red
  end
  log.info(text)
  responseFromTIR.clear
  responseFromTIRtoXML = String.new
end
rescue Exception => msg
puts "Ошибка: \n#{msg}"
log.warn(msg)
end