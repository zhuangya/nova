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
      $scope.itemToBuy = [$scope.detailId, clothes.inventory[0].slug, clothes.inventory[0].sizes[0].name].join('/');
    });

    $scope.selectVariant = function(size) {
      $scope.itemToBuy = [$scope.detailId, $scope.currentInventory.slug, size.name].join('/');
    };

    $scope.addToCart = function ($event, clothes) {
      $event.preventDefault();
      $http.post('/api/cart', {
        name: $scope.itemToBuy,
        count: $scope.quantity,
        unit_price: $scope.clothes.price
      }).success(function (resp) {
      }).error(function (error) {
      });
    };

    $scope.updateVariant = function(invt) {
      $scope.currentInventory = invt;
    };

  });
