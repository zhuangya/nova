'use strict';

angular.module('frontendApp')
  .controller('DetailCtrl', function ($scope, $routeParams, $http) {

    $scope.detailId = [$routeParams.category, $routeParams.slug].join('/');

    $http.get('/data/' + $scope.detailId).success(function(clothes) {
      clothes.image = ['/data', clothes.id,  clothes.main_name].join('/');
      $scope.clothes = clothes;
    });

    $scope.addToCart = function (clothes) {

      $http.post('/api/cart', {
        //TODO: fix this request payload.
        name: clothes.name,
        unit_price: clothes.price
      }).success(function (resp) {
      }).error(function (error) {
      });

    };

  });
