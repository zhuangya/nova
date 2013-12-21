'use strict';

angular.module('frontendApp')
  .controller('DetailCtrl', function ($scope, $routeParams) {
    $scope.detailId = $routeParams.detailId;
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];
  });
