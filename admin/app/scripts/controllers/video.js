'use strict';

angular.module('adminApp')
  .controller('VideoCtrl', function ($scope, $http, $q, APIBASE) {

    $http.get(APIBASE + '/data/video').success(function(videos) {
      $scope.videoList = videos;
    });

    $scope.addVideo = function() {
      $http.post(APIBASE + '/api/admin/video', $scope.video).success(function(videos) {
        $scope.videoList = videos;
      });
      $scope.video = {};
    };

  });
