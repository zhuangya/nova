'use strict';

angular.module('frontendApp')
  .controller('MeCtrl', function ($scope, $http) {
    $http.get('/api/cart').success(function (clothes) {
      $scope.clothes = clothes;
    });
    
  });
