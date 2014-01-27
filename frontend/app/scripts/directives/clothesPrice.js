'use strict';

angular.module('frontendApp')
  .directive('clothesPrice', function () {
    return {
      scope: {
        clothes: '@'
      },
      templateUrl: 'views/directives/clothesPrice.html',
      restrict: 'A'
    };
  });
