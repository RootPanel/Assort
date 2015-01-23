Mallard = require './index'
mallard = new Mallard Mallard.fromFile()

mallard.task 'accounts', '<0.1.0', (db, callback) ->
  console.log 'task accounts'
  callback()

mallard.task 'database', '<=0.1.1', (db, callback) ->
  console.log 'task database'
  callback()

mallard.task 'clean', null, (db, callback) ->
  console.log 'task clean'
  callback()

mallard.migrate '0.1.2', 'db', ->
  console.log arguments
