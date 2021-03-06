#coding: utf-8
#ocra auto_answer_activemq.rb --no-dep-run

require 'stomp'
require 'rexml/document'
include REXML
exit_requested = false
Kernel.trap( "INT" ) { exit_requested = true } #Выход по нажатию Ctrl+C


answer_BS_R_STM_ABS_A = '\\\\vm-corint\TIR\ETALON_XML\TIR21-СвязьБанк_Retail\BS_R_STM\BS_R_STM_ABS_A.xml'
answer_BS_R_CARDACC_ABS_A = '\\\\vm-corint\TIR\ETALON_XML\TIR21-СвязьБанк_Retail\BS_R_CARDACC\BS_R_CARDACC_ABS_A.xml'
answer_BS_R_CARDSTM_ABS_A = '\\\\vm-corint\TIR\ETALON_XML\TIR21-СвязьБанк_Retail\BS_R_CARDSTM\BS_R_CARDSTM_ABS_A.xml'
answer_BS_R_CCONV_ABS_A = '\\\\vm-corint\TIR\ETALON_XML\TIR21-СвязьБанк_Retail\BS_R_CCONV\BS_R_CCONV_ABS_A.xml'
answer_BS_R_CREDITPAY_ABS_A = '\\\\vm-corint\TIR\ETALON_XML\TIR21-СвязьБанк_Retail\BS_R_CREDITPAY\BS_R_CREDITPAY_ABS_A.xml'
answer_DepositClose_ABS_A = '\\\\vm-corint\TIR\ETALON_XML\TIR21-СвязьБанк_Retail\DepositClose\DepositClose_ABS_A.xml'
answer_BS_R_ACCACC_ABS_A = '\\\\vm-corint\TIR\ETALON_XML\TIR21-СвязьБанк_Retail\BS_R_ACCACC\BS_R_ACCACC_ABS_A.xml'
answer_BS_R_OPENDEPOSIT_ABS_A = '\\vm-corint\TIR\ETALON_XML\TIR21-СвязьБанк_Retail\BS_R_OPENDEPOSIT\BS_R_OPENDEPOSIT_ABS_A.xml'

puts "Запустили автоматический ответ в ТИР от АБС для связки банка Связь Банк Retail"
puts "Для выхода нажмите Ctrl+C\n"
while !exit_requested
#Подключаемся к MQ
begin
client = Stomp::Client.new('admin', 'admin', 'vm-opentir', 61613)
request = ''
client.subscribe('/queue/szvABS_in'){|msg| request << msg.body.to_s}
client.join(1)
if request.length > 0
  request_from_abs = Document.new(request)
  if request_from_abs.elements['//ns0:BSMessage'].attributes['xmlns:ns0'] == 'BS_R_STM'
    answer = Document.new(File.open(answer_BS_R_STM_ABS_A){ |file| file.read })
  elsif request_from_abs.elements['//ns0:BSMessage'].attributes['xmlns:ns0'] == 'BS_R_CARDACC'
    answer = Document.new(File.open(answer_BS_R_CARDACC_ABS_A){ |file| file.read })
  elsif request_from_abs.elements['//ns0:BSMessage'].attributes['xmlns:ns0'] == 'BS_R_CARDSTM'
    answer = Document.new(File.open(answer_BS_R_CARDSTM_ABS_A){ |file| file.read })
  elsif request_from_abs.elements['//ns0:BSMessage'].attributes['xmlns:ns0'] == 'BS_R_CCONV'
    answer = Document.new(File.open(answer_BS_R_CCONV_ABS_A){ |file| file.read })
  elsif request_from_abs.elements['//ns0:BSMessage'].attributes['xmlns:ns0'] == 'BS_R_CREDITPAY'
    answer = Document.new(File.open(answer_BS_R_CREDITPAY_ABS_A){ |file| file.read })
  elsif request_from_abs.elements['//ns0:BSMessage'].attributes['xmlns:ns0'] == 'BS_R_CLOSEDEPOSIT'
    answer = Document.new(File.open(answer_DepositClose_ABS_A){ |file| file.read })
  elsif request_from_abs.elements['//ns0:BSMessage'].attributes['xmlns:ns0'] == 'BS_R_ACCACC'
    answer = Document.new(File.open(answer_BS_R_ACCACC_ABS_A){ |file| file.read })
  elsif request_from_abs.elements['//ns0:BSMessage'].attributes['xmlns:ns0'] == 'BS_R_OPENDEPOSIT'
    answer = Document.new(File.open(answer_BS_R_OPENDEPOSIT_ABS_A){ |file| file.read })
  end
  answer.elements['//ns1:BSMessage'].attributes['ID'] = request_from_abs.elements['//ns0:BSMessage'].attributes['ID']
  client.publish('/queue/szvABS_out', answer.to_s) #Кидаем запрос в очередь
  if answer.elements['//ns1:BSMessage'].attributes['ID'] == ''
    puts "[#{Time.now}] Обработали запрос #{request_from_abs.elements['//ns0:BSMessage'].attributes['xmlns:ns0']} из очереди szvABS_in с пустым ID, видимо, не заполнен Correlation ID в запросе"
  else
    puts "[#{Time.now}] Обработали запрос #{request_from_abs.elements['//ns0:BSMessage'].attributes['xmlns:ns0']} из очереди szvABS_in с ID = #{request_from_abs.elements['//ns0:BSMessage'].attributes['ID']}"
  end
end
client.close
rescue Exception => msg
  puts "Ошибка: \n#{msg}"
end
end