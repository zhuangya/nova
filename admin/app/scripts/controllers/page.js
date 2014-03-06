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

    $scope.onFileSelect = function(files) {
      _.each(files, function(file) {
      $scope.upload = $upload.upload({
        url: '/api/admin/bg',
        data: {
          name: 'hell'
        },
        file: file,
        fileFormDataName: 'background'
      }).success(function(data) {
        console.log(data);
        console.log('bg uploaded');
      });
      });
    };

    $scope.uploadBg = function (slug) {
      event.preventDefault();
      $http({
        method: 'POST',
        url: '/api/admin/bg',
        headers: {
          'Content-Type': 'multipart/form-data'
        },
        data: {
          background: $scope.background,
          name: slug
        },
        transformRequest: function(data) {
          var fd = new FormData();
          angular.forEach(data, function(value, key) {
            fd.append(key, value);
          });
          return fd;
        }
      });
    };
  });
