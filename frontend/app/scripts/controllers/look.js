'use strict';

angular.module('frontendApp')
  .controller('LookCtrl', function ($scope, $http, $q, $compile) {

    window.waterFallLooks = [
      { "height": 401, "width": 600, "src": "images/tees/lb001.jpg" },
      { "height": 899, "width": 600, "src": "images/tees/lb003.jpg" },
      { "height": 899, "width": 600, "src": "images/tees/lb002.jpg" },
      { "height": 900, "width": 600, "src": "images/tees/lb004.jpg" },
      { "height": 900, "width": 600, "src": "images/tees/lb005.jpg" },
      { "height": 401, "width": 600, "src": "images/tees/lb008.jpg" },
      { "height": 900, "width": 600, "src": "images/tees/lb007.jpg" },
      { "height": 900, "width": 600, "src": "images/tees/lb006.jpg" },
      { "height": 401, "width": 600, "src": "images/tees/lb009.jpg" }
    ];

    $scope.waterFall = waterFallLooks;

    $scope.showImg = function (img) {
      $scope.showZoom = true;
      $scope.zoomImg = img;
    };

  });
