'use strict';

angular.module('adminApp')
  .controller('ClothesCtrl', function ($scope) {
    $scope.addClothes = function() {
      console.log($scope.clothes);
    };
  });
