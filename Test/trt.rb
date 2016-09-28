require "wx"
include Wx
require 'interface.xrc' # наш дизайн

# Создаем наш класс, который наследует класс нарисованной формы
class RubyRSSMainFrame < RubyRSSFrame
  # Инициализация класса
  def initialize
    # Вызов инициализации родителя
    super
  end
end

# Запуск приложения на основе нашего класса
Wx::App.run do
  RubyRSSMainFrame.new.show
end