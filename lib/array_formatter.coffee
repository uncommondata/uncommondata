Stream = require('stream').Stream
eventPresenter = require('../app/presenters/event_presenter')

class ArrayFormatter extends Stream
  constructor: () ->
    @writable = true
    @_done = false

  write: (doc) =>
    event = JSON.stringify(eventPresenter(doc));
    if @_hasWritten
      @emit('data', ',') 
    else
      @emit('data', '[') unless @_hasWritten
      @_hasWritten = true
    @emit('data', event) 
    true

  end: =>
    @destroy()

  destroy: =>
    unless @done
      @done = true
      @emit('data', '[') unless @_hasWritten
      @emit('data', ']')
      @emit('end')

module.exports = ArrayFormatter