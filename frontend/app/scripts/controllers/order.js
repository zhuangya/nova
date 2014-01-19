'use strict';

angular.module('frontendApp')
  .controller('OrderCtrl', function ($scope, $http) {
    $http.get('/api/cart').success(function (cart) {
      $scope.cart = cart;
    }).error(function (error) {
      console.log(error);
    });
  });
