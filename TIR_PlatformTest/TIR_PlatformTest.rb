#coding: utf-8
#ocra auto_answer_activemq.rb --no-dep-run

require 'stomp'
require 'rexml/document'
include REXML

component = {
    'Хранимые процедуры'=> false,
    'ActiveMq'          => true}

#Переменные путей
inputqueue = "/queue/tir_in"    #Входящая очередь ТИР
outputqueue = "/queue/test_out" #Исходящая очередь ТИР
route_DBAdapter = '\\\\vm-corint\TIR\ETALON_XML\TIR_AutoTest\PayDocRu_request.xml' #Маршрут проверки ХП
activeMQlistner = '\\\\vm-corint\TIR\ETALON_XML\TIR_AutoTest\BS_R_CCONV_R.xml'
answer_BS_R_STM_ABS_A = '\\\\vm-corint\TIR\ETALON_XML\TIR_AutoTest\BS_R_CCONV_ABS_A.xml'

begin
# Очищаем очередь
client = Stomp::Client.new('admin', 'admin', 'vm-opentir', 61613)
client.subscribe(outputqueue){|msg| puts "Очередь #{outputqueue} очищена" if msg.body.to_s}
client.join(1)
client.subscribe('/queue/test_activemq_out'){|msg| puts "Очередь '/queue/test_activemq_out' очищена" if msg.body.to_s}
client.join(1)
client.close
responseFromTIR = String.new
requestFromTIR = String.new

################################################################################################################################################

  puts "\nЗапустили автотесты маршрутов в #{Time.now}\n\n"
  if component['Хранимые процедуры']
    request = File.open(route_DBAdapter){|file| file.read}

    client = Stomp::Client.new('admin', 'admin', 'vm-opentir', 61613)
    client.publish(inputqueue, request)
    sleep 5
    client.subscribe(outputqueue){|msg| responseFromTIR << msg.body.to_s}
    client.join(1)
    client.close

    responseFromTIRtoXML = Document.new(responseFromTIR)
    if responseFromTIRtoXML.elements['//p:Ticket'].attributes['statusStateCode'] == 'ACCEPTED_BY_ABS'
    puts "Адаптер Active MQ работает\nКомпонент трансформации работает\nКомпонент взаимодействия с БД работает"
    else puts "Проверка компонента взаимодействия с БД провалилась!"
    end
  end

    if component['ActiveMq']
        request = File.open(activeMQlistner){|file| file.read}

        client = Stomp::Client.new('admin', 'admin', 'vm-opentir', 61613)
        client.publish(inputqueue, request)
        sleep 5
        client.subscribe('/queue/test_activemq_out'){|msg| requestFromTIR << msg.body.to_s}
        client.join(1)
        if request.length > 0
            requestFromTIRtoXML = Document.new(requestFromTIR)
            answer = Document.new(File.open(answer_BS_R_STM_ABS_A){ |file| file.read })
            answer.elements['//ns1:BSMessage'].attributes['ID'] = requestFromTIRtoXML.elements['//ns0:BSMessage'].attributes['ID']
            client.publish('/queue/szvABS_out', answer.to_s) #Кидаем запрос в очередь
            if answer.elements['//ns1:BSMessage'].attributes['ID'] == ''
                puts "[#{Time.now}] Обработали запрос #{requestFromTIRtoXML.elements['//ns0:BSMessage'].attributes['xmlns:ns0']} из очереди szvABS_in с пустым ID, видимо, не заполнен Correlation ID в запросе"
            else
                puts "[#{Time.now}] Обработали запрос #{requestFromTIRtoXML.elements['//ns0:BSMessage'].attributes['xmlns:ns0']} из очереди szvABS_in с ID = #{requestFromTIRtoXML.elements['//ns0:BSMessage'].attributes['ID']}"
            end
        end
        client.subscribe(outputqueue){|msg| responseFromTIR << msg.body.to_s}
        client.join(1)
        puts responseFromTIR
        client.close
        end

rescue Exception => msg
puts "Ошибка: \n#{msg}"
end