'use strict';

angular.module('adminApp')
  .controller('ClothesCtrl', function ($scope, $http, $location, $routeParams, APIBASE) {
    $scope.clothes = {};

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

    $scope.variants = [];
    $scope.addVariant = function() {

      //TODO: send http request here.

      $scope.variants.push({
        variant: $scope.clothes.variant,
        quantity: $scope.clothes.inventory
      });

      //TODO: clear the variant and inventory in the $http success callback.
    };
  });

angular.module('adminApp')
  .controller('uploadCtrl', function($scope, $http, $routeParams, $upload, APIBASE) {
    var _id = $routeParams.id || '';
    _id = _id.replace(/\|/, '/');
    var url = APIBASE + '/api/admin/data/' + _id + '/upload';
    $scope.onFileSelect = function($files, name) {
      angular.forEach($files, function(file) {
        $scope.upload = $upload.upload({
          url: url,
          method: 'POST',
          file: file,
          data: {
            name: name
          },
          fileFormDataName: 'payload'
        }).progress(function(event) {
          console.log('percent: %s', parseInt(100.0 * event.loaded / event.total));
        }).success(function(resp) {
          console.log(resp);
          $http.post(APIBASE + '/api/admin/data/reload').success(function(resp) {
            console.log(resp);
          });
        });
      });
    };
  });
