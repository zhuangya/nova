'use strict';

angular.module('adminApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'angularFileUpload'
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
      .when('/clothes/:action', {
        pageName: 'clothes',
        templateUrl: 'views/clothes.html',
        controller: 'ClothesCtrl'
      })
      .when('/clothes/:id/:action', {
        pageName: 'clothes',
        templateUrl: 'views/clothes.html',
        controller: 'ClothesCtrl'
      })
      .when('/clothes/:action/:category/:slug', {
        pageName: 'clothes',
        templateUrl: 'views/clothes.html',
        controller: 'ClothesCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  });

angular.module('adminApp')
  .controller('HeaderCtrl', function($scope) {
    $scope.$on('$routeChangeSuccess', function(scope, current) {
      $scope.pageName = current.$$route.pageName || '';
    });
  });


angular.module('adminApp').constant('APIBASE', 'http://benzex.com');
