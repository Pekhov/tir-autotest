#coding: utf-8
require "wx"
include Wx

class TestFrame < Frame
  def initialize
    super nil, :title => "Тест, просто тест. -)"
    @bt = Wx::Button.new(self,-1,"Ня?") #Создаем кнопку. Примечательно, что при помощи ссылки self она сама себя добавит во фрейм.
    evt_button @bt.get_id, :bt_evt #в случае <s>пожара</s>нажатия кнопки вызвать bt_evt()
  end
  def bt_evt
    MessageDialog.new(self, "Как-бы тест. -)", 'Тест', OK).show_modal #создаём диалог и отображаем его с помощью show_modal()
  end
end

App.run do #странно, но все действия с окнами нужно делать в этом блоке.
  fr = TestFrame.new #создаём экземпляр нашего класса...
  fr.show #...и показываем окно. ;-)
end