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
  });
