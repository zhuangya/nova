'use strict';

angular.module('frontendApp')
  .directive('usercard', function () {
    return {
      scope: {
        who: '='
      },
      templateUrl: 'views/directives/usercard.html',
      restrict: 'A',
      controller: function ($scope, $http) {
        $http.get('/api/user').success(function(user) {
          $scope.user = user.profile._json;
          console.log($scope.user);
        });
      },
      link: function postLink(scope, element, attrs) {

      }
    };
  });
