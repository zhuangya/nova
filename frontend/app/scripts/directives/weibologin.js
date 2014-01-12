'use strict';

angular.module('frontendApp')
  .directive('weiboLogin', function () {
    return {
      //template: '<a href="/auth/weibo">weibologin</a>{{msg.screen_name}}',
      templateUrl: 'views/directives/weiboLogin.html',
      restrict: 'A',
      controller: function ($scope, $http, $location) {
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
