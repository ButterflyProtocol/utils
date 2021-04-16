// const web3 = require('web3-utils');
const { utils } = require('web3')
const bloom = require('ethereum-bloom-filters');
const sig = require('eth-sig-util');

const Utils = {
  EmptyAddr: '0x0000000000000000000000000000000000000000',
  EmptyBytes32: '0x' + Buffer.alloc(32).toString('hex'),

  namehash(fqn) {
    const sha3 = Utils.soliditySha3;
    return fqn.split('.').reduceRight((node, label) => {
      if (label) {
        return sha3(node, sha3({t: 'string', v: label}));
      } else {return node;}
    }, Utils.EmptyBytes32);
  },

  nh(fqn) { return Utils.namehash(fqn); },

  namehashFromParent(parent, label) {
    let sha3 = Utils.soliditySha3;
    return sha3(parent, sha3({t: 'string', v: label}));
  }
};

Object.assign(Utils, utils, bloom, sig);

module.exports = Utils;
