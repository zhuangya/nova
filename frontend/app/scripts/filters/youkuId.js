'use strict';

angular.module('frontendApp')
  .filter('youkuId', function () {
    return function (input) {
      return input.replace(/id_(\w+)\.html/, '$1');
    };
  });
