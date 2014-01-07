'use strict';

angular.module('frontendApp')
  .controller('NewCtrl', function ($scope, $http, $log, APIBASE) {
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];
    $scope.nos = {
      avatar: 'http://placekitten.com/64/64'
    };

    $http.get(APIBASE + '/data').success(function (product) {
      $scope.goods = _.map(product, function(p) {
        p.coverImage = [APIBASE, 'photo', p.id, p.cover_name].join('/');
        return p;
      });

    });
  });
