require 'nokogiri'
require 'ostruct'
require 'open-uri'
require 'active_support/core_ext/hash/conversions'

doc = Nokogiri::Slop <<-EOXML
<employees>
<employee status="active">
<fullname>Dean Martin</fullname>
  </employee>
<employee status="inactive">
<fullname>Jerry Lewis</fullname>
  </employee>
</employees>
EOXML

puts doc.employees.status.content
