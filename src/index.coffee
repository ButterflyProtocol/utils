Utils = {
  chunk: (input, size) ->
    input.slice((size*i), (size*i)+size) for i in [0...(input.length/size)]

  padBuffer: (buf, size) ->
    if @isBuffer(buf)
      if buf.length <= size
        Buffer.concat([buf, Buffer.alloc(size - buf.length)])
      else throw new Error('Buffer is too large to pad')
    else throw new TypeError('Must be a buffer')

  padHex: (hex, size) ->
    if @isHex(hex)
      if hex.length <= (size * 2 + 2)
        @bufferToHex(@padBuffer(@hexToBuffer(hex), size))
      else throw new Error('Hex string is too large to pad')
    else throw new TypeError('Must be a hex string')

  isString: (str) -> typeof str == 'string'

  isArray: (arr) -> Array.isArray(arr)

  isBuffer: (buf) -> Buffer.isBuffer(buf)

  isHex: (str) ->
    @isString(str) && str.match(/^0x([0-9a-fA-F]{2})*$/)?

  isBufferArray: (bufarr) ->
    if @isArray(bufarr) && bufarr.length then bufarr.every(@isBuffer)
    else false

  isHexArray: (hexarr) ->
    if @isArray(hexarr) && hexarr.length then hexarr.every((hex) => @isHex(hex))
    else false

  detect: (val) ->
    if @isBuffer(val) then 'buffer'
    else if @isHex(val) then 'hex'
    else if @isBufferArray(val) then 'bufferArray'
    else if @isHexArray(val) then 'hexArray'
    else if @isString(val) then 'string'
    else if @isArray(val) then 'array'
    else 'unknown'

  bufferToHex: (buf) ->
    if @isBuffer(buf) then '0x' + buf.toString('hex')
    else throw new TypeError('Must be a buffer')

  hexToBuffer: (hex) ->
    if @isHex(hex) then Buffer.from(hex.slice(2), 'hex')
    else throw new TypeError('Must be a hex string')

  bufferArrayToHexArray: (bufarr) ->
    if @isBufferArray(bufarr) then @bufferToHex(buf) for buf in bufarr
    else throw new TypeError('Must be a buffer array')

  hexArrayToBufferArray: (hexarr) ->
    if @isHexArray(hexarr) then @hexToBuffer(hex) for hex in hexarr
    else throw new TypeError('Must be a hex array')

  bufferArrayToBuffer: (bufarr) ->
    if @isBufferArray(bufarr) then Buffer.concat((bufarr))
    else throw new TypeError('Must be a buffer array')

  hexArrayToHex: (hexarr) -> @bufferArrayToHex(@hexArrayToBufferArray(hexarr))

  bufferArrayToHex: (bufarr) -> @bufferToHex(@bufferArrayToBuffer(bufarr))

  hexArrayToBuffer: (hex) -> @bufferArrayToBuffer(@hexArrayToBufferArray(hex))

  bufferToBufferArray: (buf, chunk=buf.length) ->
    if @isBuffer(buf) then @padBuffer(b, chunk) for b in @chunk(buf, chunk)
    else throw new TypeError('Must be a buffer')

  hexToHexArray: (hex, chunk) ->
    if @isHex(hex) then @bufferToHexArray(@hexToBuffer(hex), chunk)
    else throw new TypeError('Must be a hex string')

  bufferToHexArray: (buf, chunk) ->
    if @isBuffer(buf)
      @bufferToHex(b) for b in @bufferToBufferArray(buf, chunk)
    else throw new TypeError('Must be a buffer')

  hexToBufferArray: (hex, chunk) ->
    if @isHex(hex) then @bufferToBufferArray(@hexToBuffer(hex), chunk)
    else throw new TypeError('Must be a hex string')

  anyToBuffer: (val) ->
    switch @detect(val)
      when 'buffer' then val
      when 'hex' then @hexToBuffer(val)
      when 'bufferArray' then @bufferArrayToBuffer(val)
      when 'hexArray' then @hexArrayToBuffer(val)
      else throw new TypeError('Unsupported Type')
}

module.exports = Utils
