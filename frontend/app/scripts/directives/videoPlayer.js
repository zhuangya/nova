'use strict';

angular.module('frontendApp')
  .directive('videoPlayer', function ($compile) {
    return {
      scope: {
        videoId: '@'
      },
      templateUrl: 'views/directives/videoPlayer.html',
      restrict: 'A',
      link: function(scope, element, attrs) {
        scope.key='hello';
        scope.videoId='world';
        console.log( $compile(element.contents())(scope).html() );
      }
    };
  });
