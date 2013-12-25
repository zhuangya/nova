'use strict';

angular.module('frontendApp')
  .directive('weiboLogin', function () {
    return {
      template: '<div><a href="http://benzex.com/auth/weibo">weibo login</a></div>',
      restrict: 'A'
    };
  });
