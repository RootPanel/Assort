# Assort
Tools for manage migration scripts.

## Usages:

    Assort = require 'assort'
    assort = new Assort 'rootpanel', Assort.fromFile('.version')

Define tasks:

    assort.task 'accounts', '<1.2.3', (db, callback) ->
      db.accounts.update {},
        $rename:
          name: 'username'
      ,
        multi: true
      , callback

    assort.task 'database', '<=1.2.4', (db, callback) ->
      #...

The task will be run every time if version is `null`:

    assort.task 'database', null, (db, callback) ->
      db.dropCollection 'temp_data', callback

Run migration:

    assort.migrate require('./package').version, db, (err) ->
