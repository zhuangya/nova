'use strict';

angular.module('frontendApp')
  .directive('weiboLogin', function () {
    return {
      templateUrl: 'views/directives/weiboLogin.html',
      restrict: 'A',
      controller: function ($scope, $http, $location) {
        $scope.showBox = false;
        //$scope.reg = {};

        $scope.register = function () {
          $http.post('/api/register', $scope.reg).success(function () {
            $scope.login({
              email: $scope.reg.email,
              password: $scope.reg.password
            });
          });
        };

        $scope.login = function (loginInfo) {
          $http.post('/api/login', loginInfo).success(function () {
            $location.url('/');
          });
        };

        $scope.toggleBox = function () {
          $scope.showBox = !$scope.showBox;
        };

        $scope.logout = function() {
          $http.get('/auth/logout').success(function () {
            window.location = '/';
          });
        };
        $http.get('/api/user').success(function(who) {
          $scope.who= who.profile._json;
          $scope.isAuth = true;
        }).error(function(error) {
          $scope.isAuth = false;
        });
      }
    };
  });
