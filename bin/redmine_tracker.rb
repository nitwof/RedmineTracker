require 'Qt'
require 'require_all'
require_all 'lib'

Action.store.create(Action.table) unless Action.store.exists?(Action.table)

unless Settings.store.exists?(Settings.table)
  Settings.store.create(Settings.table)
end

unless Transaction.store.exists?(Transaction.table)
  Transaction.store.create(Transaction.table)
end

app = Qt::Application.new ARGV
Application.new(app.desktop.screen)
app.exec
