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
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      })
      .when('/new', {
        templateUrl: 'views/new.html',
        controller: 'NewCtrl'
      })
      .when('/look', {
        templateUrl: 'views/look.html',
        controller: 'LookCtrl'
      })
      .when('/v', {
        templateUrl: 'views/v.html',
        controller: 'VCtrl'
      })
      .when('/c', {
        templateUrl: 'views/c.html',
        controller: 'CCtrl'
      })
      .when('/order', {
        templateUrl: 'views/order.html',
        controller: 'OrderCtrl'
      })
      .when('/me', {
        templateUrl: 'views/me.html',
        controller: 'MeCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  });
