'use strict';

angular.module('frontendApp')
  .controller('NewCtrl', function ($scope) {
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];
    $scope.nos = {
      avatar: 'http://placekitten.com/64/64'
    };
    $scope.goods = [{
      id: 1,
      image: 'http://placekitten.com/300/300',
      size: ['XL', 'L', 'M', 'S']
    }, {
      id: 2,
      image: 'http://placekitten.com/400/340',
      size: ['XL', 'L', 'M']
    }]
  });
