'use strict';

angular.module('frontendApp')
  .directive('socialAccount', function () {
    return {
      scope: {
        nologo: '@'
      },
      templateUrl: 'views/directives/socialAccount.html',
      restrict: 'A'
    };
  });
