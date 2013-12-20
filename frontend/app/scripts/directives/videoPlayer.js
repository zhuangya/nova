'use strict';

angular.module('frontendApp')
  .directive('videoPlayer', function ($q, $compile, $window, $timeout) {
    return {
      scope: {
        vid: '@',
      },
      restrict: 'A',
      link: function postLink(scope, element, attrs) {
        element.attr('id', 'youku-' + attrs.vid);
        element.css({
          height: '400px',
          width: '480px',
          margin: 'auto'
        });

        new YKU.Player('youku-' + attrs.vid, {
          client_id: 'f8c97cdf52e7a346',
          vid: attrs.vid
        });
      }
    };
  });
