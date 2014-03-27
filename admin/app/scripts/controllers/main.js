'use strict';

angular.module('adminApp')
  .controller('MainCtrl', function ($scope, $http) {
    $scope.getWording = function () {
      $http.get('/api/wording').success(function (resp) {
        $scope.wording = resp;
      });
    };
    $scope.saveWording = function () {
      $http.post('/api/admin/wording', $scope.wording).success(function (resp) {
        console.log(resp);
      });
    };
  });
