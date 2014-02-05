'use strict';

angular.module('adminApp')
  .controller('ClothesCtrl', function ($scope, $http, $location, $routeParams) {
    $scope.clothes = {};
    $scope.clothes.variants = [];

    if ($routeParams.category && $routeParams.slug) {
      $scope.productId = [$routeParams.category, $routeParams.slug].join('/');

      $http.get('/data/' + $scope.productId).success(function(clothes) {
        $scope.clothes = clothes;
        $scope.clothes.slug = $routeParams.slug;
        $scope.clothes.category = $routeParams.category;
        $scope.clothes.price = clothes.variants[0].sizes[0].price;
      });

    }

    var _id = $routeParams.id || '';

    _id = _id.replace(/\|/, '/');

    function normalize(wat) {
      return wat.replace(/[\s-]+/g, '_');
    }

    function idlize(category, slug) {
      category = category || '';
      slug = slug || '';

      return [normalize(category), normalize(slug)].join('/');
    }

    $scope.addClothes = function () {
      $scope.clothes.id = idlize($scope.clothes.category, $scope.clothes.slug);

      _.each($scope.clothes.inventory, function(invt) {
        var slug = invt.slug;
        inventory[invt.slug] = invt;
        inventory.price = $scope.clothes.price;
        delete inventory[invt.slug].$$hashKey;
        delete inventory[invt.slug].slug;
      });

      $scope.clothes.variants = _.reduce($scope.clothes.variants, function(last, next) {
        next.sizes = _.reduce(next.sizes, function(last, next) {
          last[next.name] = next;
          return last;
        }, {});
        last[next.name] = next;
        return last;
      }, {});

      //$scope.clothes.variants = inventory;

      delete $scope.clothes.category;
      delete $scope.clothes.slug;

      $http.post('/api/admin/data', $scope.clothes).success(function(wat) {
        $location.path('clothes/' + wat.id + '/upload');
      }).error(function(error) {
        console.error(error);
      });
    };

    $scope.deleteClothes = function (clothes) {
      $http.post('/api/admin/data/' + clothes.id + '/delete').success(function (resp) {
        $http.post('/api/admin/data/reload').success(function(resp) {
        });
      });
    }

    $scope.cancel = function () {
      $location.path('clothes');
    };

    $http.get('/data').success(function(products) {
      $scope.products = products;
    }).error(function(error) {
      $scope.errmsg = error.errmsg;
      console.log(error);
    });

    $scope.addVariant = function() {
      $scope.variant.sizes = _.map($scope.variant.sizes, function(count, key) {
        return {
          name: key,
          price: $scope.clothes.price,
          inventory: count
        };
      });
      $scope.clothes.variants.push($scope.variant);
      $scope.variant = {};
    };

    $scope.deleteVariant = function(waste) {
      $scope.clothes.variants = _.reject($scope.clothes.variants, function(vant) {
        return _.isEqual(waste, vant);
      });
    };

    //$scope.addVariant = function () {
      //// var newVariant = _.object([$scope.variant.slug], [$scope.variant.name]);
      //var newVariant = {
        //slug: $scope.variant.slug,
        //name: $scope.variant.name
      //};

      //var repeatId = _.indexOf($scope.clothes.inventory, _.find($scope.clothes.inventory, function(inv) {
        //return inv.slug === $scope.variant.slug;
      //}));

      //// now we find out the repeat one, update it!

      //if (repeatId !== -1) {
        //$scope.clothes.inventory[repeatId] = newVariant;
      //} else {
        //$scope.clothes.inventory.push(newVariant);
      //}

    //};

  });

angular.module('adminApp')
  .controller('ClothesUploadCtrl', function($scope, $http, $routeParams, $upload, $location) {

      $scope.productId = [$routeParams.category, $routeParams.slug].join('/');
      $http.get('/data/' + $scope.productId).success(function(clothes) {
        $scope.coverPreview = ['/data', $scope.productId, 'cover.jpg'].join('/');
        $scope.mainPreview = ['/data', $scope.productId, 'main.jpg'].join('/');
      });

    var _id = [$routeParams.category, $routeParams.slug].join('/');
    var url = '/api/admin/data/' + _id + '/upload';
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
          if (name === 'cover.jpg') {
            $scope.coverPreview = '/data' + resp.path;
          } else {
            $scope.mainPreview = '/data' + resp.path;
          }

        });

        $scope.slot = function() {
          $http.post('/api/admin/data/reload').success(function(resp) {
            $location.path('clothes');
          });
        };
      });
    };
  });

