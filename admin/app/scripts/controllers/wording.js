'use strict';

angular.module('adminApp')
  .controller('WordingCtrl', function ($scope, $location, $routeParams, $http) {
    $scope.section = $routeParams.section;

    var oldWording;

    if (!$routeParams.section) {
      $location.path('wording/subtitle');
    }

    $http.get('/api/wording').success(function (wording) {
      oldWording = wording;
      $scope.wording = wording;
      $scope.sectionList = _.keys($scope.wording);
      $scope.wordingContent = wording[$scope.section];
    });

    $scope.saveWording = function () {
      oldWording[$scope.section] = $scope.wordingContent;
      $http.post('/api/admin/wording', oldWording).success(function (resp) {
        console.log(resp);
      });
    };


  });
