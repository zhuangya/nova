'use strict';

angular.module('frontendApp')
  .controller('CCtrl', function ($scope, $http) {
    $http.get('/api/wording', {
      cache: true
    }).success(function (resp) {
      console.log(resp);
      $scope.about = resp.about;
      $scope.contact = resp.contact;
    });
  });
