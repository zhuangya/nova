'use strict';

angular.module('frontendApp')
  .directive('navbar', function () {
    return {
      templateUrl: 'views/directives/navbar.html',
      restrict: 'A',
      link: function(scope, element, attrs) {
        scope.orientation = attrs.orientation;
      }
    };
  });
