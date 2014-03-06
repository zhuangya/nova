'use strict';

angular.module('adminApp')
  .controller('PageCtrl', function ($scope, $http, $upload) {
    $http.get('/api/bg').success(function(pages) {
      $scope.pages = pages;
    });

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
          page.path = [data.path, +new Date()].join('?');
        });
      });
    };
  });
