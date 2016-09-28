require 'xmlsimple'
config = XmlSimple.xml_in('C:\Ruby\test.xml', { 'KeyAttr' => 'name' })
puts config["character"]