const Chai = require('chai');

Chai
  .use(require('chai-as-promised'))
  .should();

global.expect = Chai.expect;
