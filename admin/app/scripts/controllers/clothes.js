'use strict';

angular.module('adminApp')
  .controller('ClothesCtrl', function ($scope, $http, $location, $routeParams, APIBASE) {
    $scope.clothes = {};
    $scope.upload = {};

    $scope.action = $routeParams.action || 'list';
    var _id = $routeParams.id || '';

    _id = _id.replace(/\|/, '/');

    function normalize(wat) {
      return wat.replace(/\s+/g, '-');
    }

    function idlize(category, slug) {
      category = category || '';
      slug = slug || '';

      return [normalize(category), normalize(slug)].join('/');
    }

    $scope.addClothes = function () {
      $scope.clothes.id = idlize($scope.clothes.category, $scope.clothes.slug);

      delete $scope.clothes.category;
      delete $scope.clothes.slug;

      $http.post(APIBASE + '/api/admin/data', $scope.clothes).success(function(wat) {
        console.log(wat);
        $location.path('clothes/' + wat.id.replace(/\//, '|') + '/upload');
      }).error(function(error) {
        console.error(error);
      });
    };

    $scope.cancel = function () {
      $location.path('clothes');
    };

    $http.get(APIBASE + '/data').success(function(products) {
      $scope.products = products;
    });
  });

angular.module('adminApp')
  .controller('uploadCtrl', function($scope, $routeParams, APIBASE) {
    var _id = $routeParams.id || '';
    var url = APIBASE + '/admin/data/' + _id + '/upload';

    $scope.completed = function(content) {
      console.log(content);
    };

  });
