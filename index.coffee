semver = require 'semver'
async = require 'async'
fs = require 'fs'
_ = require 'underscore'

logger = ->
  args = _.toArray arguments
  args.unshift '[Assort]'
  console.log.apply @, args

versionFromFile = (filename = '.version', name = 'version') ->
  return {
    name: name

    readVersion: (callback) ->
      fs.exists filename, (exists) ->
        if exists
          fs.readFile filename, (err, body) ->
            if err
              callback err
            else
              callback err, JSON.parse(body.toString())[name]

        else
          callback null, null

    saveVersion: (version, callback) ->
      writeVersion = (config) ->
        config ?= {}
        config[name] = version

        fs.writeFile filename, JSON.stringify(config), callback

      fs.exists filename, (exists) ->
        if exists
          fs.readFile filename, (err, body) ->
            if err
              callback err
            else
              writeVersion JSON.parse body.toString()

        else
          writeVersion()
  }

versionFromMongoDB = (uri, collection = '_version', name = 'version') ->
  {MongoClient} = require 'mongodb'

  return {
    name: name

    readVersion: (callback) ->
      MongoClient.connect uri, (err, db) ->
        return callback err if err
        db.collection(collection).findOne
          name: name
        , (err, doc) ->
          if err
            callback err

          else if doc
            callback err, doc?.version

          else
            callback err, null

    saveVersion: (version, callback) ->
      MongoClient.connect uri, (err, db) ->
        return callback err if err
        db.collection(collection).update
          name: name
        ,
          $set:
            version: version
        ,
          upsert: true
        , (err, doc) ->
          if err
            callback err

          else if doc
            callback err, doc?[name]

          else
            callback err, null

  }

class Assort
  tasks: []

  # storage: readVersion(callback(err)), saveVersion(version, callback(err))
  constructor: (storage) ->
    _.extend @,
      storage: storage

  # callback(err)
  migrate: (latest_version, resource, callback) ->
    {storage, tasks} = @

    unless latest_version
      return callback 'missing latest_version'

    logger "start migrate: #{storage.name}, latest_version: #{latest_version}"

    storage.readVersion (err, current_version) ->
      return callback err if err

      logger "read version, current_version: #{current_version}"

      async.eachSeries tasks, (task, callback) ->
        if current_version and task.version and !semver.satisfies(current_version, task.version)
          logger "skip task #{task.name}(#{task.version})"
          return callback()

        logger "run task #{task.name}(#{task.version}) ..."
        task.worker resource, callback

      , (err) ->
        if err
          logger 'migrate error', err
          callback err
        else
          logger "save version, current_version: #{latest_version}"
          storage.saveVersion latest_version, callback

  # worker(resource, callback(err))
  task: (name, version, worker) ->
    @tasks.push
      name: name
      version: version
      worker: worker

module.exports = _.extend Assort,
  fromFile: versionFromFile
  fromMongoDB: versionFromMongoDB
