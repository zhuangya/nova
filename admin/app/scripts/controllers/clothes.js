'use strict';

angular.module('adminApp')
  .controller('ClothesCtrl', function ($scope, $location, $routeParams) {
    $scope.action = $routeParams.action || 'list';
    $scope.addClothes = function () {
      console.log($scope.clothes);
    };
    $scope.cancel = function () {
      $location.path('clothes');
    };

  });
