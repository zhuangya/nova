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
      .when('/detail/:detailId', {
        pageClass: 'new',
        templateUrl: 'views/detail.html',
        controller: 'DetailCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  }).run(function($route, $rootScope) {
    $rootScope.$on('$routeChangeSuccess', function(event, current) {
      $rootScope.pageClass = current.$$route.pageClass || '';
    });
  });

angular.module('frontendApp').value('CLOTHES', [{
      id: 1,
      image: 'images/tees/1.jpg',
      size: ['XL', 'L', 'M', 'S']
    }, {
      id: 2,
      image: 'images/tees/2.jpg',
      size: ['XL', 'L', 'M']
    }, {
      id: 3,
      image: 'images/tees/3.jpg',
      size: ['XL', 'L', 'M']
    }, {
      id: 4,
      image: 'images/tees/4.jpg',
      size: ['XL', 'L', 'M']
    }, {
      id: 5,
      image: 'images/tees/5.jpg',
      size: ['XL', 'L', 'M']
    }, {
      id: 6,
      image: 'images/tees/6.jpg',
      size: ['XL', 'L', 'M']
    }, {
      id: 7,
      image: 'images/tees/7.jpg',
      size: ['XL', 'L', 'M']
    }]);
