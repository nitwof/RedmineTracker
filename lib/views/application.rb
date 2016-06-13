require 'fox16'

include Fox

class Application < FXApp
  def initialize(app_name, vendor_name)
    super(app_name, vendor_name)
    @main_window = MainWindow.new(self, 'Redmine Tracker', 800, 600)
    self.create
  end
end
