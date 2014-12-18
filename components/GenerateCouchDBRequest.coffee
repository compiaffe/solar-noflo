noflo = require 'noflo'
mydesigndoc = []
myviewname = []
exports.getComponent = ->
  c = new noflo.Component
  c.description = "Generate a CouchDB request string from the user input"

  c.inPorts.add 'ddocid',
    datatype: 'string'
    required: true    
    description: 'Name of the design doc present on the couchDB'
  , (event, payload) ->
    switch event
      when 'data'
        mydesigndoc = payload
      when 'disconnect'
        return

  c.inPorts.add 'viewname',
    datatype: 'string'
    required: true
    description: 'the view I would like to use'
  , (event, payload) ->
    switch event
      when 'data'
        myviewname = payload
      when 'disconnect'
        return
  
  c.inPorts.add 'startkey',
    datatype: 'string'

  c.inPorts.add 'endkey',
    datatype: 'string'

  c.inPorts.add 'starttime',
    datatype: 'array'
    
  c.inPorts.add 'endtime',
    datatype: 'array'

  c.outPorts.add 'out',
    datatype: 'string'
    description: 'string request for the couchdb view reader'

  noflo.helpers.WirePattern c,
    in: ['startkey', 'endkey', 'starttime', 'endtime']
    out: 'out'
    forwardGroups: true
  , (data, groups, out) ->
    return if mydesigndoc == [] and myviewname == []
    if data.endkey = []
      data.endkey = data.startkey
    if data.endtime = []
      data.endtime = "{}"
    unless data.starttime = []
      data.starttime = ", #{data.starttime}"
    out.send "{ \"designDocID\": \"#{mydesigndoc}\", \"viewName\": \"#{myviewname}\", \"params\": { \"startkey\": [ \"#{data.startkey}\"#{data.starttime}], \"endkey\": [ \"#{data.endkey}\",#{data.endtime}]  } }"

  c