'use strict';

angular.module('frontendApp')
  .directive('usercard', function () {
    return {
      scope: {
        who: '='
      },
      templateUrl: 'views/directives/usercard.html',
      restrict: 'A',
      link: function postLink(scope, element, attrs) {

      }
    };
  });
