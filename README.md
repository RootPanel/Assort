# Mallard
Tools for manage migration scripts.

## Usages:

    Mallard = require 'mallard'
    mallard = new Mallard 'rootpanel', Mallard.fromFile('.version')

Define tasks:

    mallard.task 'accounts', '<1.2.3', (db, callback) ->
      db.accounts.update {},
        $rename:
          name: 'username'
      ,
        multi: true
      , callback

    mallard.task 'database', '<=1.2.4', (db, callback) ->
      #...

The task will be run every time if version is `null`:

    mallard.task 'database', null, (db, callback) ->
      db.dropCollection 'temp_data', callback

Run migration:

    mallard.migrate require('./package').version, db, (err) ->
