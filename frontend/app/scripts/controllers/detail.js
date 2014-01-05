'use strict';

angular.module('frontendApp')
  .controller('DetailCtrl', function ($scope, $routeParams, $http, APIBASE) {

    $scope.detailId = [$routeParams.category, $routeParams.slug].join('/');

    $http.get(APIBASE + '/data/' + $scope.detailId).success(function(clothes) {
      $scope.clothes = clothes;
    });
  });
