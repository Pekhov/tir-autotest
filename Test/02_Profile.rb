# -*- encoding : utf-8 -*-
require 'watir-webdriver'
browser = Watir::Browser.new :chrome

#Создание профиля безопасности
browser.goto("http://vm-corint/sbns-web/main.zul")
browser.text_field(:id => "userName").set "bank"
browser.text_field(:id => "password").set "12345"
browser.button(:id => "submitButton").click
browser.span.element(:xpath, "//*[text()='Профили пользователей']").when_present.click
browser.button(:title => "Создать").when_present.click