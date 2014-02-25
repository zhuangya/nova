'use strict';

angular.module('frontendApp')
  .directive('usercard', function () {
    return {
      scope: {
        mini: '@',
        color: '@',
        seek: '@'
      },
      templateUrl: 'views/directives/usercard.html',
      restrict: 'A',
      controller: function ($scope, $location, $http) {
        $scope.logout = function () {
          smoke.confirm('确定登出当前帐号吗？', function (event) {
            if (event) {
              $http.get('/auth/logout').success(function (resp) {
                $location.path('/');
              })
            }
          })
        };
        $http.get('/api/user').success(function(user) {
          if (user.profile) {
            user = _.extend(user, user.profile._json);
            user.avatar = user.avatar_large;
            delete user.profile._json;
          } else {
            user.avatar = 'http://gravatar.com/avatar/' + md5(user.email);
          }
          $scope.user = user;
        }).error(function (error) {
          if (error.errno === 403) {
            $scope.needLogin = true
          }
        });
      },
      link: function (scope, element, attrs) {
        if (attrs.seek !== 'no') {
          scope.usercardWrapperStyle = {
            top: $(window).innerHeight() - 100,
            left: '10px'
          };
        }
      }
    };
  });
