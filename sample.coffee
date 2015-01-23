Assort = require './index'
assort = new Assort Assort.fromFile()

assort.task 'accounts', '<0.1.0', (db, callback) ->
  console.log 'task accounts'
  callback()

assort.task 'database', '<=0.1.1', (db, callback) ->
  console.log 'task database'
  callback()

assort.task 'clean', null, (db, callback) ->
  console.log 'task clean'
  callback()

assort.migrate '0.1.2', 'db', ->
  console.log arguments
