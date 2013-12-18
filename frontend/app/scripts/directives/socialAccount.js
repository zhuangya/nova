'use strict';

angular.module('frontendApp')
  .directive('socialAccount', function () {
    return {
      scope: {
        logo: '@'
      },
      templateUrl: 'views/directives/socialAccount.html',
      restrict: 'A'
    };
  });
