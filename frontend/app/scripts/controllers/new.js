'use strict';

angular.module('frontendApp')
  .controller('NewCtrl', function ($scope, $http, $log) {

    $http.get('/api/wording', {
      cache: true
    }).success(function (resp) {
      $scope.subtitle = resp.subtitle;
    });
    $http.get('/data').success(function (product) {
      $scope.goods = _.map(product, function(p) {
        p.coverImage = ['/data', p.id, p.cover_name].join('/');
        return p;
      });
    });
  });
