'use strict';

angular.module('adminApp')
  .controller('PageCtrl', function ($scope, $http, $upload) {
    $scope.pages = [{
      display_name: '首页',
      name: 'homepage'
    }, {
      display_name: '详情',
      name: 'detail'
    }];

    $scope.onFileSelect = function(files, page) {
      _.each(files, function(file) {
        $scope.upload = $upload.upload({
          url: '/api/admin/bg',
          data: {
            slug: page.name
          },
          file: file,
          fileFormDataName: 'background'
        }).success(function(data) {
          page.image = data.path;
        });
      });
    };
  });
