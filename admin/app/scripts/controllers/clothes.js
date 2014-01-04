'use strict';

angular.module('adminApp')
  .controller('ClothesCtrl', function ($scope, $http, $location, $routeParams, APIBASE) {
    $scope.clothes = {};

    $scope.action = $routeParams.action || 'list';

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

      console.log($scope.clothes);

      $http.post(APIBASE + '/api/admin/data', $scope.clothes).success(function(wat) {
        console.log(wat);
      }).error(function(error) {
        console.error(error);
      });
    };

    $scope.cancel = function () {
      $location.path('clothes');
    };

  });
