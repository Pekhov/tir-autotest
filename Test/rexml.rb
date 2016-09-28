#coding: utf-8
require 'colorize'
require 'rexml/document'
include REXML

xmlfile = File.open('\\\\vm-corint\TIR\ETALON_XML\TIR21-Diasoft68\PayDocRu_response.xml')
xmldoc = Document.new(xmlfile)
x = 1
puts "waaa #{x}" if xmldoc.elements['//p:Ticket'].attributes['statusStateCode'] == 'ACCEPTED_BY_ABS'