chai = require 'chai'
expect = chai.expect

Utils = require '../src'

describe 'Utils', ->
  before ->
    @hex = '0x0102030405060708090a0b0c'
    @hexa = '0x0102030405060708'
    @hexb = '0x090a0b0c'
    @paddedHexb = '0x090a0b0c00000000'

    @buf = Buffer.from('0102030405060708090a0b0c', 'hex')
    @bufa = Buffer.from('0102030405060708', 'hex')
    @bufb = Buffer.from('090a0b0c', 'hex')
    @paddedBufb = Buffer.from('090a0b0c00000000', 'hex')

  describe 'chunk', ->
    it 'should chunk a string', ->
      result = Utils.chunk('this is a test', 8)
      expect(result).to.eql(['this is ', 'a test'])

    it 'should chunk a buffer', ->
      result = Utils.chunk(@buf, 8)
      expect(result).to.eql([@bufa, @bufb])

  describe 'padBuffer', ->
    it 'should right pad a buffer to size with 00 bytes', ->
      result = Utils.padBuffer(@bufb, 8)
      expect(result).to.eql(@paddedBufb)

    it 'should not pad a buffer that is already the right size', ->
      result = Utils.padBuffer(@bufa, 8)
      expect(result).to.eql(@bufa)

  describe 'padHex', ->
    it 'should right pad a hex string to size with 00 bytes', ->
      result = Utils.padHex(@hexb, 8)
      expect(result).to.eql(@paddedHexb)

    it 'should not pad a hex string that is already the right size', ->
      result = Utils.padHex(@hexa, 8)
      expect(result).to.eql(@hexa)

  describe 'isString', ->
    it 'should return true for a string', ->
      result = Utils.isString('test')
      expect(result).to.be.true

    it 'should return false for a buffer', ->
      result = Utils.isString(Buffer.alloc(0))
      expect(result).to.be.false

  describe 'isArray', ->
    it 'should return true for an array', ->
      result = Utils.isArray([])
      expect(result).to.be.true

    it 'should return false for a string', ->
      result = Utils.isArray('test')
      expect(result).to.be.false

    it 'should return false for a buffer', ->
      result = Utils.isArray(Buffer.alloc(0))
      expect(result).to.be.false

  describe 'isBuffer', ->
    it 'should return true for a buffer', ->
      result = Utils.isBuffer(Buffer.alloc(2))
      expect(result).to.be.true

    it 'should return false for a string', ->
      result = Utils.isBuffer('test')
      expect(result).to.be.false

  describe 'isHex', ->
    it 'should return true for a valid hex string starting with 0x', ->
      result = Utils.isHex('0x010203')
      expect(result).to.be.true

    it 'should return true for a valid hex string with only 0x', ->
      result = Utils.isHex('0x')
      expect(result).to.be.true

    it 'should return false if passed a buffer', ->
      result = Utils.isHex(Buffer.from('010203', 'hex'))
      expect(result).to.be.false

    it 'should return false if the string does not start with 0x', ->
      result = Utils.isHex('010203')
      expect(result).to.be.false

    it 'should return false if the string does not contain even number of nibbles', ->
      result = Utils.isHex('0x01020')
      expect(result).to.be.false

    it 'should return false if the string contains non hex characters', ->
      result = Utils.isHex('0x010203test')
      expect(result).to.be.false

  describe 'isBufferArray', ->
    it 'should return true for a valid buffer array', ->
      result = Utils.isBufferArray([@bufa, @bufb])
      expect(result).to.be.true

    it 'should return false for an array that contains non buffers', ->
      result = Utils.isBufferArray([@buf, @hex])
      expect(result).to.be.false

  describe 'isHexArray', ->
    it 'should return true for a valid hex array', ->
      result = Utils.isHexArray([@hexa, @hexb])
      expect(result).to.be.true

    it 'should return false for an array that contains non hex', ->
      result = Utils.isHexArray([@buf, @hex])
      expect(result).to.be.false

  describe 'detect', ->
    it 'should return buffer if passed a buffer', ->
      result = Utils.detect(@buf)
      expect(result).to.equal('buffer')

    it 'should return hex if passed a hex string', ->
      result = Utils.detect(@hex)
      expect(result).to.equal('hex')

    it 'should return bufferArray if passed a buffer array', ->
      result = Utils.detect([@bufa, @bufb])
      expect(result).to.equal('bufferArray')

    it 'should return hexArray if passed a hex array', ->
      result = Utils.detect([@hexa, @hexb])
      expect(result).to.equal('hexArray')

    it 'should return string if passed a string', ->
      result = Utils.detect('test')
      expect(result).to.equal('string')

    it 'should return array if passed an array', ->
      result = Utils.detect([0])
      expect(result).to.equal('array')

    it 'should return emptyArray if passed an empty array', ->
      result = Utils.detect([])
      expect(result).to.equal('emptyArray')

    it 'should return unknown if passed an unknown type', ->
      result = Utils.detect(1000)
      expect(result).to.equal('unknown')

  describe 'bufferToHex', ->
    it 'should turn a buffer into a hex string', ->
      result = Utils.bufferToHex(@buf)
      expect(result).to.equal(@hex)

  describe 'hexToBuffer', ->
    it 'should turn a hex string into a buffer', ->
      result = Utils.hexToBuffer(@hex)
      expect(result).to.eql(@buf)

  describe 'bufferArrayToHexArray', ->
    it 'should turn a buffer array into a hex array', ->
      result = Utils.bufferArrayToHexArray([@bufa, @bufb])
      expect(result).to.eql([@hexa, @hexb])

  describe 'hexArrayToBufferArray', ->
    it 'should turn a buffer array into a hex array', ->
      result = Utils.hexArrayToBufferArray([@hexa, @hexb])
      expect(result).to.eql([@bufa, @bufb])

  describe 'bufferArrayToBuffer', ->
    it 'should turn a buffer array into a buffer', ->
      result = Utils.bufferArrayToBuffer([@bufa, @bufb])
      expect(result).to.eql(@buf)

  describe 'hexArrayToHex', ->
    it 'should turn a buffer array into a buffer', ->
      result = Utils.hexArrayToHex([@hexa, @hexb])
      expect(result).to.eql(@hex)

  describe 'bufferArrayToHex', ->
    it 'should turn a buffer array into a hex string', ->
      result = Utils.bufferArrayToHex([@bufa, @bufb])
      expect(result).to.equal(@hex)

  describe 'hexArrayToBuffer', ->
    it 'should turn a hex array into a buffer', ->
      result = Utils.hexArrayToBuffer([@hexa, @hexb])
      expect(result).to.eql(@buf)

  describe 'bufferToBufferArray', ->
    it 'should turn a buffer into a buffer array', ->
      result = Utils.bufferToBufferArray(@buf)
      expect(result).to.eql([@buf])

    it 'should turn a buffer into a buffer array split into chunks', ->
      result = Utils.bufferToBufferArray(@buf, 8)
      expect(result).to.eql([@bufa, @paddedBufb])

  describe 'hexToHexArray', ->
    it 'should turn a hex string into a hex array', ->
      result = Utils.hexToHexArray(@hex)
      expect(result).to.eql([@hex])

    it 'should turn a hex string into a hex array split into chunks', ->
      result = Utils.hexToHexArray(@hex, 8)
      expect(result).to.eql([@hexa, @paddedHexb])

  describe 'bufferToHexArray', ->
    it 'should turn a buffer into a hex array', ->
      result = Utils.bufferToHexArray(@buf)
      expect(result).to.eql([@hex])

    it 'should turn a buffer into a hex array split into chunks', ->
      result = Utils.bufferToHexArray(@buf, 8)
      expect(result).to.eql([@hexa, @paddedHexb])

  describe 'hexToBufferArray', ->
    it 'should turn a hex string into a buffer array', ->
      result = Utils.hexToBufferArray(@hex)
      expect(result).to.eql([@buf])

    it 'should turn a hex string into a buffer array split into chunks', ->
      result = Utils.hexToBufferArray(@hex, 8)
      expect(result).to.eql([@bufa, @paddedBufb])

  describe 'anyToBuffer', ->
    it 'should turn a buffer into a buffer', ->
      result = Utils.anyToBuffer(@buf)
      expect(result).to.eql(@buf)

    it 'should turn a hex string into a buffer', ->
      result = Utils.anyToBuffer(@hex)
      expect(result).to.eql(@buf)

    it 'should turn a buffer array into a buffer', ->
      result = Utils.anyToBuffer([@bufa, @bufb])
      expect(result).to.eql(@buf)

    it 'should turn a hex array into a buffer', ->
      result = Utils.anyToBuffer([@hexa, @hexb])
      expect(result).to.eql(@buf)

