Stream = require('stream').Stream

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

global.ArrayFormatter = ArrayFormatter

# // // function ArrayFormatter () {
# // //   Stream.call(this);
# // //   this.writable = true;
# // //   this._done = false;
# // // }
 
# // // ArrayFormatter.prototype.__proto__ = Stream.prototype;
 
# // ArrayFormatter.prototype.write = function (doc) {
# //   event = JSON.stringify(eventPresenter(doc));
# //   if (! this._hasWritten) {
# //     this._hasWritten = true;
# //     // open an object literal / array string along with the doc
# //     this.emit('data', '[' + event);
# //   } else {
# //     this.emit('data', ',' + event);
# //   }
 
# //   return true;
# // }
 
# // ArrayFormatter.prototype.end =
# // ArrayFormatter.prototype.destroy = function () {
# //   if (this._done) return;
# //   this._done = true;
 
# //   // close the object literal / array
# //   this.emit('data', ']');
# //   // done
# //   this.emit('end');
# // }

