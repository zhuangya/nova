'use strict';

angular.module('frontendApp')
  .controller('LookCtrl', function ($scope, $http, $q, $compile) {

    $scope.waterFall = [
      { "height": 401, "width": 600, "src": "images/lb001.jpg" },
      { "height": 899, "width": 600, "src": "images/lb003.jpg" },
      { "height": 899, "width": 600, "src": "images/lb002.jpg" },
      { "height": 900, "width": 600, "src": "images/lb004.jpg" },
      { "height": 900, "width": 600, "src": "images/lb005.jpg" },
      { "height": 401, "width": 600, "src": "images/lb008.jpg" },
      { "height": 900, "width": 600, "src": "images/lb007.jpg" },
      { "height": 900, "width": 600, "src": "images/lb006.jpg" },
      { "height": 401, "width": 600, "src": "images/lb009.jpg" }
    ];

    $scope.showImg = function (img) {
      $scope.showZoom = true;
      $scope.zoomImg = img;
    };

  });
