'use strict';

angular.module('frontendApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute'
])
  .config(function ($routeProvider) {
    $routeProvider
      .when('/', {
        pageClass: 'homepage',
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      })
      .when('/new', {
        pageClass: 'new',
        templateUrl: 'views/new.html',
        controller: 'NewCtrl'
      })
      .when('/look', {
        pageClass: 'look',
        templateUrl: 'views/look.html',
        controller: 'LookCtrl'
      })
      .when('/v', {
        pageClass: 'v',
        templateUrl: 'views/v.html',
        controller: 'VCtrl'
      })
      .when('/c', {
        pageClass: 'c',
        templateUrl: 'views/c.html',
        controller: 'CCtrl'
      })
      .when('/order', {
        pageClass: 'order',
        templateUrl: 'views/order.html',
        controller: 'OrderCtrl'
      })
      .when('/me', {
        pageClass: 'me',
        templateUrl: 'views/me.html',
        controller: 'MeCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  }).run(function($route, $rootScope) {
    $rootScope.$on('$routeChangeSuccess', function(event, current) {
      $rootScope.pageClass = current.$$route.pageClass || '';
    });
  });
