'use strict';

angular.module('adminApp')
  .controller('ClothesCtrl', function ($scope, $http, $location, $routeParams) {
    $scope.clothes = {};

    if ($routeParams.category && $routeParams.slug) {
      $scope.productId = [$routeParams.category, $routeParams.slug].join('/');

      $http.get('/data/' + $scope.productId).success(function(clothes) {
        $scope.clothes = clothes;
        $scope.clothes.slug = $routeParams.slug;
        $scope.clothes.category = $routeParams.category;
      });

    }

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

      $http.post('/api/admin/data', $scope.clothes).success(function(wat) {
        $location.path('clothes/' + wat.id + '/upload');
      }).error(function(error) {
        console.error(error);
      });
    };

    $scope.cancel = function () {
      $location.path('clothes');
    };

    $http.get('/data').success(function(products) {
      $scope.products = products;
    }).error(function(error) {
      $scope.errmsg = error.errmsg;
      console.log(error);
    });

    $scope.variants = [];
    $scope.addVariant = function(id) {

      var dataToSend = {};

      $http.post('/api/admin/data/' + id, dataToSend).success(function(wat) {
        console.log(wat);
      });

      //TODO: send http request here.

      $scope.variants.push({
        variant: $scope.clothes.variant,
        quantity: $scope.clothes.inventory
      });

      _.each($scope.variants, function(v) {
      });


      $scope.clothes.variant = '';
      $scope.clothes.inventory = '';
    };

    $scope.deleteVariant = function (evil) {
      $scope.variants = _.reject($scope.variants, function (variant) {
        return _.isEqual(variant, evil);
      });
    };
  });

angular.module('adminApp')
  .controller('ClothesUploadCtrl', function($scope, $http, $routeParams, $upload) {
    var _id = [$routeParams.category, $routeParams.slug].join('/');
    var url = '/api/admin/data/' + _id + '/upload';
    console.log(url);
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
          $http.post('/api/admin/data/reload').success(function(resp) {
            console.log(resp);
          });
        });
      });
    };
  });

