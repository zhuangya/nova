'use strict';

angular.module('adminApp')
  .filter('youkuId', function () {
    // example: http://v.youku.com/v_show/id_XNjUwNjIxNDA0.html
    return function (input) {
      var youkuRegExp = /v\.youku\.com\/v_show\/id_(\w+)\.html/;
      var result = input.match(youkuRegExp);
      if (result) {
        return result[1];
      } else {
        return '';
      }
    };
  });
