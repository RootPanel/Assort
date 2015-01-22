versionFromFile = (filename) ->

versionFromMongoDB = (uri, collection, key) ->

class Mallard
  # storage: readVersion(callback(err)), saveVersion(version, callback(err))
  constructor: (name, storage) ->

  # callback(err)
  migrate: (latest_version, resource, callback) ->

  # worker(resource, callback(err))
  task: (name, version, worker) ->

module.exports = _.extend Mallard,
  fromFile: versionFromFile
  fromMongoDB: versionFromMongoDB
