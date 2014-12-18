# File: components/Forwarder.coffee
noflo = require "noflo"

exports.getComponent = ->
  component = new noflo.Component
  component.description = "This component receives data on a single input
  port and sends the same data out to the output port"

  # Register ports and event handlers
  component.inPorts.add 'in', datatype: 'all', (event, payload) ->
    switch event
      when 'data'
        # Forward data when we receive it.
        # Note: send() will connect automatically if needed
        component.outPorts.out.send payload
      when 'disconnect'
        # Disconnect output port when input port disconnects
        component.outPorts.out.disconnect()
  component.outPorts.add 'out', datatype: 'all'

  component # Return new instance