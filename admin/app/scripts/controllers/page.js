'use strict';

angular.module('adminApp')
  .controller('PageCtrl', function ($scope) {
    $scope.pages = [{
      display_name: '首页',
      name: 'homepage'
    }, {
      display_name: '详情',
      name: 'detail'
    }];

    $scope.uploadBg = function (slug) {
      event.preventDefault();
      console.log(slug);
    };
  });
