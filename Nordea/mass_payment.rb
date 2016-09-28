#coding: windows-1251
x = 12500
head = '<?xml version="1.0" encoding="windows-1251"?>
    <Documents xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:noNamespaceSchemaLocation="file:/D:/proj/sbns_temp/dbo/src/main/resources/com/bssys/sbns/dbo/rur/payment/importing/ImportPayDocRu.xsd">
'
end_file = '</Documents>'
file = File.open('C:\Users\Pekav\Downloads\XML_MASS.xml', 'w')
file.write head
2500.times do
  file.write '<PayDocRu branchExtId="2000"
             branchId="04e94d00-4284-49af-b22f-46d1748c0ee1"
             dateTimeCreate="2016-07-12T12:35:36"
             docId="49f14c3d-adc2-46cf-a930-680a7339'+rand(1000..9000).to_s+'"
             extOrgId="777"
             firstSign="ФИО"
             orgId="ef9464b5-19a3-471e-bbea-ba6005f3aff7"
             receiptDate="2016-07-12"
             receiptTime="12:35:33.570">
      <AccDoc accDocNo="'+(x+1).to_s+'"
              docDate="2016-07-12"
              docNum="'+(x=x+1).to_s+'"
              docSum="123.00"
              paytCode="1"
              paytKind="электронно"
              priority="3"
              purpose="sd.&#xD;&#xA;В том числе НДС 18.00 % - 18.76."
              transKind="01"/>
      <Payer inn="123456789012"
             kpp="123456789"
             personalAcc="40801810811111111111">
         <Name>ЗАО Тестовая организация</Name>
         <Bank bic="044525225" correspAcc="30101810400000000225">
            <BankName>ОАО "СБЕРБАНК РОССИИ" Г. МОСКВА</BankName>
            <Name>ОАО "СБЕРБАНК РОССИИ"</Name>
            <BankCity>МОСКВА</BankCity>
            <SettlementType>Г</SettlementType>
         </Bank>
      </Payer>
      <Payee inn="1111111111"
             kpp="111111111"
             personalAcc="40801810011111111111"
             uip="12345678901234567890">
         <Name>Наименование корреспондента</Name>
         <Bank bic="040021002">
            <BankName>ПУ БАНКА РОССИИ N 83604</BankName>
            <Name>ПУ БАНКА РОССИИ N 83604</Name>
            <SettlementType/>
         </Bank>
      </Payee>
      <DepartmentalInfo cbc="39511621090090000140"
                        docDate="01.01.2014"
                        docNo="777"
                        drawerStatus="01"
                        okato="0"
                        paytReason="АП"
                        taxPeriod="МС.01.2014"
                        taxPeriodDay="МС"
                        taxPeriodMonth="01"
                        taxPeriodYear="2014"/>
      <Signs>
         <SignDesc cryptoProvider="OneTimePassword"
                   signDate="2016-06-10T12:35:23"
                   signTypeDesc="SINGLE"
                   value="ФИО"/>
      </Signs>
   </PayDocRu>
'
end
file.write end_file
file.close

