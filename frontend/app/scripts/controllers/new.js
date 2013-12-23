'use strict';

angular.module('frontendApp')
  .controller('NewCtrl', function ($scope, CLOTHES) {
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];
    $scope.nos = {
      avatar: 'http://placekitten.com/64/64'
    };
    $scope.goods = CLOTHES;
  });
