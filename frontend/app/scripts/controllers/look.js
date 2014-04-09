'use strict';

angular.module('frontendApp')
  .controller('LookCtrl', function ($scope, $http, $q, $compile) {

    $scope.waterFall = [
      { "height": 1000, "width": 1000, "src": "images/tees/lookbook.jpg" }
    ];

    $scope.showImg = function (img) {
      $scope.showZoom = true;
      $scope.zoomImg = img;
    };

  });
