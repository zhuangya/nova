'use strict';

angular.module('frontendApp')
  .controller('DetailCtrl', function ($scope, $routeParams, $http) {

    $scope.detailId = [$routeParams.category, $routeParams.slug].join('/');

    $http.get('/data/' + $scope.detailId).success(function(clothes) {
      clothes.image = ['/data', clothes.id,  clothes.main_name].join('/');
      clothes.inventory = _.map(clothes.inventory, function(invt, slug) {
        invt.slug = slug;
        invt.sizes = _.compact(_.map(invt, function(value, key) {
          if (/^(?:s|m|x?l)$/.test(key)) {
            return {
              'name': key,
              'quantity': value
            };
          }
          return null;
        }));
        delete invt.s;
        delete invt.m;
        delete invt.l;
        delete invt.xl;

        return invt;
      });

      $scope.clothes = clothes;
      $scope.currentInventory = clothes.inventory[0];
    });

    $scope.selectVariant = function(size) {
      console.log($scope.currentInventory.slug, size.name);
    };

    $scope.addToCart = function (clothes) {
      $http.post('/api/cart', {
        //TODO: fix this request payload.
        name: clothes.name,
        unit_price: clothes.price
      }).success(function (resp) {
      }).error(function (error) {
      });
    };

    $scope.updateVariant = function(invt) {
      $scope.currentInventory = invt;
    };

  });
