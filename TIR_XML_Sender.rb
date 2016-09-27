#coding: utf-8
require 'stomp'
require 'colorize'
require 'yaml'
require 'securerandom'

puts <<"EOF"
Список возможных для отправки в очередь ТИР документов:
1 - РПП                           (PayDocRu)
2 - Перевод валюты                (PayDocCur)
3 - Покупка валюты                (CurrBuy)
4 - Продажа валюты                (CurrSell)
5 - Конверсия валюты              (CurrConv)
6 - Перевод с транзитного счета   (MandatorySaleBox)
7 - Запрос выписки                (StatementRequest)
8 - Запрос выписки (системный)    (SystemStatementRequest)
9 - Запрос статуса                (DocId)
10 -Запрос на отзыв               (CancelRequest)
11- СВО                           (CurrDealCertificate138I)
12- СПД                           (ConfDocCertificate138I)
13- ПСпК                          (DealPassCon138I)
14- ПСпКД                         (DealPassCred138I)

EOF
loop do
  puts 'Введите значения в формате:'
  print '"№ нужного документа, префикс", например "1,inversion": '
  arr = gets.chomp.split(',').to_a
  arr[1].nil? ? prefix = "" : prefix = arr[1].strip
  doc = {1=>"PayDocRu", 2=>"PayDocCur", 3=>"CurrBuy", 4=>"CurrSell", 5=>"CurrConv", 6=>"MandatorySaleBox", 7=>"StatementRequest",8=>"SystemStatementRequest",
         9=>"DocId", 10=>"CancelRequest", 11=>"CurrDealCertificate138I", 12=>"ConfDocCertificate138I", 13=>"DealPassCon138I", 14=>"DealPassCred138I"}
  path_xml = Dir["\\\\vm-corint/TIR/ETALON_XML/Standart/*#{doc[arr[0].to_i]}*"]
  if doc[arr[0].to_i].nil?
    print "Такой документ не найден"
    gets
    exit
  else
    puts "Документ: '#{doc[arr[0].to_i]}', префикс: '#{prefix}'"
  end
#Формируем сообщение
  xmlfile = File.open(path_xml[0].to_s){ |file| file.read }
  def make_message(file, prefix, message)
    file.each_line do |line|
      line.gsub!("<", "<#{prefix}:")
      line.gsub!("<#{prefix}:/", "</#{prefix}:")
      line.gsub!("xmlns=", "xmlns:#{prefix}=")
      line.gsub!("xmlns:Dbo", "xmlns:#{prefix}Dbo")
      line.gsub!("<#{prefix}:?xml", "<?xml")
      line.gsub!("2016-08-01", "#{Time.now.strftime("%Y-%m-%d")}")
      line.gsub!("be117125-ae3b-4fa7-abde-49dd88c1c128",SecureRandom.uuid)
      message << line
    end
    return message
  end
  prefix.empty? ? message = xmlfile : make_message(xmlfile, prefix, message = String.new)
#Отправка сообщения в Active MQ
  begin
    config = YAML::load_file('.\config.conf')
    server =  config['Correqts 2.2.0']['TIR Active MQ host']
    port =    config['Correqts 2.2.0']['TIR Active MQ port']
    queue =   config['Correqts 2.2.0']['TIR Active MQ queue']
    login =   config['Correqts 2.2.0']['TIR Active MQ login']
    password= config['Correqts 2.2.0']['TIR Active MQ password']
    client = Stomp::Client.new(login, password, server, port)
    client.publish("/queue/#{queue}", message) #Кидаем запрос в очередь
    client.close
    puts "Сообщение отправлено в очередь ТИР #{queue} на сервере #{server}:#{port}"
  rescue Exception => msg
    puts "Ошибка!\n".red + "Выгрузка не удалась: \n#{msg}"
  end
  print "\nНажмите ENTER для еще одной отправки документа"
  answer = gets.chomp
  if answer.empty?
    puts "\n"
  else
    puts "Выходим..."
    break
  end
end