'use strict';

angular.module('frontendApp')
  .directive('videoPlayer', function ($q, $compile, $window, $timeout) {
    return {
      scope: {
        url: '@',
      },
      restrict: 'A',
      link: function postLink(scope, element, attrs) {
        var vid;

        attrs.url.replace(/id_(\w+)\.html/, function(match, id) {
          vid = id;
        });

        element.attr('id', 'youku-' + vid);
        element.css({
          height: '400px',
          width: '480px',
          margin: 'auto'
        });

        new YKU.Player('youku-' + vid, {
          client_id: 'f8c97cdf52e7a346',
          vid: vid
        });
      }
    };
  });
