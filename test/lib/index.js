const Util = require('../../lib');

describe('Util', () => {
  describe('web3-util', () => {
    it('should include web3-utils', async () => {
      let result = Util.sha3;
      (typeof result).should.equal('function');
    });
  });

  describe('namehash', () => {
    it('should', async () => {
      let result = Util.namehash('foo.eth');
      result.should.equal('0xde9b09fd7c5f901e23a3f19fecc54828e9c848539801e86591bd9801b019f84f');
    });
  });
});
