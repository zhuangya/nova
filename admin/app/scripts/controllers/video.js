'use strict';

angular.module('adminApp')
  .controller('VideoCtrl', function ($scope, $http, $q) {

    $http.get('/data/video').success(function(videos) {
      $scope.videoList = videos;
    });

    $scope.addVideo = function() {
      $http.post('/api/admin/video', $scope.video).success(function(videos) {
        $scope.videoList = videos;
      });
      $scope.video = {};
    };

    $scope.deleteVideo = function(video) {
      console.log(video);
    };

  });
