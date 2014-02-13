'use strict';

angular.module('frontendApp')
  .controller('MeCtrl', function ($scope, $http) {
    $http.get('/api/cart').success(function (clothes) {
      $scope.cart = clothes;
      $scope.hasClothes = !!clothes.length;
      $scope.total = _.reduce(clothes, function (total, c) {
        return total + c.count * c.unit_price;
      }, 0);
    });
  });
