'use strict';

angular.module('frontendApp')
  .controller('DetailCtrl', function ($scope, $routeParams, $http, APIBASE) {

    $scope.detailId = [$routeParams.category, $routeParams.slug].join('/');

    $http.get(APIBASE + '/data/' + $scope.detailId).success(function(clothes) {
      $scope.clothes = clothes;
    });

    $scope.addToCart = function (clothes) {

      $http.post(APIBASE + '/api/cart', {
        //TODO: fix this request payload.
        name: clothes.name,
        unit_price: clothes.price
      }).success(function (resp) {
      }).error(function (error) {
      });

    };

  });
