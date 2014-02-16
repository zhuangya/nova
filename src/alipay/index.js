var Alipay = require('./lib/alipay').Alipay;
var config = require('../../config');

config_a = config.alipay;
config_a.host = config.hostname;

module.exports = new Alipay(config_a);
