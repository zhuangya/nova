'use strict';

angular.module('adminApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'angularFileUpload',
  'textAngular'
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
      .when('/clothes/add', {
        pageName: 'clothes',
        templateUrl: 'views/clothes_add.html',
        controller: 'ClothesCtrl'
      })
      .when('/clothes/:category/:slug/edit', {
        pageName: 'clothes',
        templateUrl: 'views/clothes_add.html',
        controller: 'ClothesCtrl'
      })
      .when('/clothes/:category/:slug/upload', {
        pageName: 'clothes',
        templateUrl: 'views/clothes_upload.html',
        controller: 'ClothesUploadCtrl'
      })
      .when('/users', {
        templateUrl: 'views/users.html',
        controller: 'UsersCtrl'
      })
      .when('/page', {
        templateUrl: 'views/page.html',
        controller: 'PageCtrl'
      })
      .when('/wording', {
        templateUrl: 'views/wording.html',
        controller: 'WordingCtrl'
      })
      .when('/wording/:section', {
        templateUrl: 'views/wording.html',
        controller: 'WordingCtrl'
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


angular.module('adminApp').constant('APIBASE', '/');

