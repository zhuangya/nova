'use strict';

angular.module('frontendApp')
  .controller('NewCtrl', function ($scope, $http, $log) {

    $http.get('/data').success(function (product) {
      $scope.goods = _.map(product, function(p) {
        p.coverImage = ['/photo', p.id, p.cover_name].join('/');
        return p;
      });
    });
  });
