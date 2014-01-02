'use strict';

angular.module('adminApp')
  .controller('ClothesCtrl', function ($scope, $routeParams) {
    $scope.action = $routeParams.action || 'list';
    $scope.addClothes = function() {
      console.log($scope.clothes);
    };
  });
