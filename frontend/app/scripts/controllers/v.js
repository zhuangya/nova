'use strict';

angular.module('frontendApp')
  .controller('VCtrl', function ($scope, $http, APIBASE) {
    $http.get(APIBASE + '/data/video?v=123').success(function (videos) {
      $scope.videos = videos;
    });
  });
