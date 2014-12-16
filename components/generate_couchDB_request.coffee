noflo = require 'noflo'


class gen_couchdb_request extends noflo.Component
  description: 'Generate a CouchDB request string from the user input'

  constructor: ->
    @mydesigndoc = []
    @myviewname = []
    @groups = []

    @inPorts = new noflo.inPorts
      ddocid:
        datatype: 'string'
        description: 'Name of the design doc present on the couchDB'
      viewname:
        datatype: 'string'
        description: 'the view I would like to use'
      startkey:
        datatype: 'string'
      endkey:
        datatype: 'string'
      starttime:
        datatype: 'array'
      endtime:
        datatype: 'array'

    @outPorts = new noflo.outPorts
      out:
        datatype: 'string'
        description: 'string request for the couchdb view reader'

  @inPorts.DesignDocID.on 'data', (data)->
    @mydesigndoc = data

  @inPorts.ViewName.on 'data', (data)->
    @myviewname = data

  noflo.helpers.WirePattern @,
    in: ['startkey', 'endkey', 'starttime', 'endtime']
    out: 'out'
    forwardGroups: true
  , (data, groups, out) ->
    return unless @mydesigndoc and @myviewname  
    out.send '{ "designDocID": #{@mydesigndoc}, "viewName": #{@myviewname}, "params": { "startkey": [ #{data.startkey}, @{data.starttime}], "endkey": [ #{data.endkey}, @{data.endtime}]  } }'

exports.getComponent = ->
  new gen_couchdb_request()