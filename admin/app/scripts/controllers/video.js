'use strict';

angular.module('adminApp')
  .controller('VideoCtrl', function ($scope, bxVideo) {

    bxVideo.query(function(resp) {
    });

    // so this is just a mock.
    $scope.videoList = [{
      name: 'mac pro 开箱',
      url: 'http://v.youku.com/v_show/id_XNjUwNjIxNDA0.html'
    }];

    $scope.addVideo = function() {
      console.log($scope.video);
    };

  });
