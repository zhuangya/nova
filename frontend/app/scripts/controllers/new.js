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
      image: 'images/tees/1.jpg',
      size: ['XL', 'L', 'M', 'S']
    }, {
      id: 2,
      image: 'images/tees/2.jpg',
      size: ['XL', 'L', 'M']
    }, {
      id: 3,
      image: 'images/tees/3.jpg',
      size: ['XL', 'L', 'M']
    }, {
      id: 4,
      image: 'images/tees/4.jpg',
      size: ['XL', 'L', 'M']
    }, {
      id: 5,
      image: 'images/tees/5.jpg',
      size: ['XL', 'L', 'M']
    }, {
      id: 6,
      image: 'images/tees/6.jpg',
      size: ['XL', 'L', 'M']
    }, {
      id: 7,
      image: 'images/tees/7.jpg',
      size: ['XL', 'L', 'M']
    }]
  });
