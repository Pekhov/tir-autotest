# -*- encoding : utf-8 -*-
require 'watir-webdriver'
require 'test/unit'

class Smoke_tests < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @browser = Watir::Browser.new :chrome
    @url = "http://vm-corint/sbns-web/main.zul"
    @user = "bank"
    @password = "12345"
  end
  def test_case
    @browser.goto(@url)
    @browser.text_field(:id => "userName").set @user
    @browser.text_field(:id => "password").set @password
    @browser.button(:id => "submitButton").click
    @browser.span.element(:xpath, "//*[text()='Календари системы']").when_present.click
    @browser.span.element(:xpath, "//tr[202]/td/div/table/tbody/tr/td[2]").click
    @browser.button(:title => "Создать").when_present.click
    @browser.text_field(:xpath, "//tr[2]/td/div/table/tbody/tr/td[2]/table/tbody/tr/td/table/tbody/tr/td/table/tbody/tr/td/div/input").when_present.set "Test_" + Random.rand(100500).to_s
    @browser.text_field(:xpath, "/html/body/div[4]/div[2]/table/tbody/tr[2]/td/div/table/tbody/tr[3]/td[2]/table/tbody/tr/td/table/tbody/tr/td/table/tbody/tr/td/div/input").set "Test_" + Random.rand(100500).to_s
#Заполнение дней
    @browser.element(:xpath, "//td/table/tbody/tr/td/span/a").click
    @browser.element(:xpath, "//div[5]/div/div/div[3]/table/tbody/tr/td/div").click
    @browser.element(:xpath, "//tr[4]/td[2]/table/tbody/tr/td/table/tbody/tr/td/span/a").click
    @browser.element(:xpath, "//div[5]/div/div/div[3]/table/tbody/tr/td/div").click
    @browser.element(:xpath, "//tr[5]/td[2]/table/tbody/tr/td/table/tbody/tr/td/span/a").click
    @browser.element(:xpath, "//div[5]/div/div/div[3]/table/tbody/tr/td/div").click
    @browser.element(:xpath, "//tr[6]/td[2]/table/tbody/tr/td/table/tbody/tr/td/span/a").when_present.click
    @browser.element(:xpath, "//div[5]/div/div/div[3]/table/tbody/tr/td/div").click
    @browser.element(:xpath, "//tr[7]/td[2]/table/tbody/tr/td/table/tbody/tr/td/span/a").when_present.click
    @browser.element(:xpath, "//div[5]/div/div/div[3]/table/tbody/tr/td/div").click
    @browser.element(:xpath, "//tr[8]/td[2]/table/tbody/tr/td/table/tbody/tr/td/span/a").when_present.click
    @browser.element(:xpath, "//div[5]/div/div/div[3]/table/tbody/tr[2]/td/div").click
    @browser.element(:xpath, "//tr[9]/td[2]/table/tbody/tr/td/table/tbody/tr/td/span/a").when_present.click
    @browser.element(:xpath, "//div[5]/div/div/div[3]/table/tbody/tr[2]/td/div").when_present.click
#Исключение
    @browser.button(:title => "Добавить").when_present.click
    @browser.text_field(:xpath, "//div/span/input").when_present.set "01.01.2017"
    @browser.element(:xpath, "//tr[2]/td[2]/table/tbody/tr/td/table/tbody/tr/td/span/a").click
    @browser.element(:xpath, "//div[7]/div/div/div[3]/table/tbody/tr/td/div").click
    @browser.text_field(:xpath, "//div[6]/div[2]/table/tbody/tr[2]/td/div/table/tbody/tr[3]/td[2]/table/tbody/tr/td/table/tbody/tr/td/table/tbody/tr/td/div/input").when_present.set "Комментарий"
    @browser.element(:xpath, "//div[6]/div[2]/table/tbody/tr/td/table/tbody/tr/td/table/tbody/tr/td/button").click
    @browser.element(:xpath, "//div[2]/table/tbody/tr/td/table/tbody/tr/td/table/tbody/tr/td/button").click
  end
  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    @browser.quit
  end
end