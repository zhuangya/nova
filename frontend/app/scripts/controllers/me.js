'use strict';

angular.module('frontendApp')
  .controller('MeCtrl', function ($scope, $http) {
    $http.get('/api/cart').success(function (clothes) {
      $scope.cart = clothes;
      $scope.hasClothes = !!clothes.length;
    });
    
  });
