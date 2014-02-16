'use strict';

angular.module('adminApp')
  .controller('UsersCtrl', function ($scope, $http) {
    $http.get('/api/admin/users').success(function (resp) {
      $scope.users = resp;
    });
  });
