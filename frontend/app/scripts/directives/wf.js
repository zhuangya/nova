'use strict';

angular.module('frontendApp')
  .directive('waterFall', function () {
    return {
      scope: {
        content: '=',
        column: '@',
        zoom: '&'
      },
      templateUrl: 'views/directives/waterfall.html',
      restrict: 'A',
      controller: function($scope, $element) {

        $scope.column = $scope.column || 4;

        var posArray = [];

        _.each(_.range($scope.column), function() {
          posArray.push(0);
        });

        $scope.pin = function (wat) {
          var minIndex = _.indexOf(posArray, _.min(posArray));

          this.left = minIndex * 240;
          this.top = posArray[minIndex];

          var shrinkedHeight = 240 / wat.width * wat.height;

          posArray[minIndex] = posArray[minIndex] + shrinkedHeight;

          this.width = 240;
          this.height = shrinkedHeight;
        };
      }
    };
  });
