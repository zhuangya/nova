'use strict';

angular.module('frontendApp')
  .directive('usercard', function () {
    return {
      scope: {
        mini: '@',
        color: '@'
      },
      templateUrl: 'views/directives/usercard.html',
      restrict: 'A',
      controller: function ($scope, $location, $http) {
        $scope.logout = function () {
          smoke.confirm('确定登出当前微博帐号吗？', function (event) {
            if (event) {
              $http.get('/auth/logout').success(function (resp) {
                $location.path('/');
              })
            }
          })
        };
        $http.get('/api/user').success(function(user) {
          $scope.user = user.profile._json;
        }).error(function (error) {
          if (error.errno === 403) {
            $scope.needLogin = true
          }
        });
      }
    };
  });
