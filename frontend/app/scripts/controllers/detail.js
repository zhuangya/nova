'use strict';

angular.module('frontendApp')
  .controller('DetailCtrl', function ($scope, $routeParams, $http) {

    $scope.detailId = [$routeParams.category, $routeParams.slug].join('/');

    $http.get('/data/' + $scope.detailId).success(function(clothes) {

      clothes.image = ['/data', clothes.id,  clothes.main_name].join('/');
      clothes.price = clothes.variants[0].sizes[0].price;

      $scope.clothes = clothes;
    });

    $scope.updateVariant = function(vant) {
      $scope.currentVariant = vant;
    };

    $scope.selectSize = function(size) {
      $scope.inventory = _.find($scope.currentVariant.sizes, function(sizeItem) {
        return sizeItem.name === size.name;
      }).inventory;

      //$scope.inventory =
      $scope.itemToBuy = [$scope.detailId, $scope.currentVariant.name, size.name].join('/');
    };

    $scope.addToCart = function ($event, clothes) {
      $event.preventDefault();
      $http.post('/api/cart', {
        name: $scope.itemToBuy,
        count: $scope.quantity,
        unit_price: $scope.clothes.price
      }).success(function (resp) {
        var msg = '已成功加入购物车';
        smoke.signal(msg, function (event) {
        }, {
          duration: 1754,
          classname: "custom-class"
        });
      }).error(function (error) {
      });
    };

  });
