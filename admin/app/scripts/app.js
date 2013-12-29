'use strict';

angular.module('adminApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute'
])
  .config(function ($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      })
      .when('/video', {
        pageName: 'video',
        templateUrl: 'views/video.html',
        controller: 'VideoCtrl'
      })
      .when('/clothes', {
        pageName: 'clothes',
        templateUrl: 'views/clothes.html',
        controller: 'ClothesCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  });

angular.module('adminApp')
  .controller('HeaderCtrl', function($scope, $route) {
    $scope.$on('$routeChangeSuccess', function(scope, current) {
      $scope.pageName = current.$$route.pageName || '';
    });
  });


angular.module('adminApp').constant('APIBASE', 'http://benzex.com');
