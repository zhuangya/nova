'use strict';

angular.module('frontendApp')
  .controller('OrderCtrl', function ($scope, $http, $q) {
    $scope.updateTotal = function () {
      $scope.total = _.reduce($scope.cart, function (price, c) {
        if (c.count < 0) c.count = 0;
        return price + c.unit_price * c.count;
      }, 0);
    };

    $scope.deleteClothes = function (clothes) {
      var _name = [clothes.category, clothes.name, clothes.variant, clothes.size].join('/');

      //TODO send delete request here.

      $http.post('/api/cart/delete', {
        name: _name
      }).success(function (resp) {
      });

      $scope.cart = _.reject($scope.cart, function (c) {
        return c._name === _name;
      });

      $scope.updateTotal();
    };

    $scope.checkout = function () {
    };

    $http.get('/api/cart').success(function (cart) {
      $scope.cart = _.map(cart, function (item) {
        parseClothesName(item.name).then(function (parsed) {
          item._name = item.name;
          angular.extend(item, parsed);
        });
        return item;
      });
      $scope.updateTotal();
    }).error(function (error) {
    });

    function parseClothesName (name) {
      var deferred = $q.defer();
      name.replace(/(\w+)\/(\w+)\/(\w+)\/(\w+)/, function(match, category, name, variant, size) {
        deferred.resolve({
          category : category,
          name : name,
          variant : variant,
          size : size
        });
      });

      return deferred.promise;
    };

  });
