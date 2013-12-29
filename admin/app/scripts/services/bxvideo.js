'use strict';

angular.module('adminApp')
  .factory('bxVideo', function ($resource, APIBASE) {
    return $resource(APIBASE + '/admin/video', {}, {
    });
  });
