'use strict';

angular.module('frontendApp')
  .controller('MeCtrl', function ($scope, $http, $q) {

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

    $scope.updateTotal = function () {
      $scope.total = _.reduce($scope.cart, function (price, c) {
        if (c.count < 0) c.count = 0;
        return price + c.unit_price * c.count;
      }, 0);
    };

    $scope.deleteOrder = function (junk) {
      junk.name = junk._name;
      $http.post('/api/cart/delete', junk).success(function (resp) {
        $scope.cart = resp;
        $scope.updateTotal();
      });
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
      $scope.hasClothes = !!cart.length;
    });
  });
