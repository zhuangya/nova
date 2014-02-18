'use strict';

angular.module('frontendApp')
  .controller('MeCtrl', function ($scope, $http, $q, $location) {
    $scope.buyer = {};

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

    $scope.sendOrder = function () {
      $http.post('/api/order').success(function (order) {
        $http.post('/api/order/' + order._id + '/submit').success(function (deal) {
          window.location = deal;
        });
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
