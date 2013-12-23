'use strict';

angular.module('frontendApp')
  .controller('DetailCtrl', function ($scope, $routeParams, CLOTHES) {
    $scope.detailId = +$routeParams.detailId;
    console.log($scope.detailId);
    $scope.clothes = _.find(CLOTHES, {
      'id': $scope.detailId
    });

  });
