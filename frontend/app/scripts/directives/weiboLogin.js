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
          loginInfo = loginInfo || {
            email: $scope.loginemail,
            password: $scope.loginpassword
          };
          $http.post('/api/login', loginInfo).success(function () {
            window.location = '/';
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
          if (who.profile) {
            who = _.extend(who, who.profile._json);
            who.link = 'http://weibo.com/' + who.profile_url;
            who.avatar = who.profile_image_url;
            delete who.profile;
          } else {
            who.avatar = 'http://gravatar.com/avatar/' + md5(who.email);
          }
          $scope.who= who;
          $scope.isAuth = true;
        }).error(function(error) {
          $scope.isAuth = false;
        });
      }
    };
  });
