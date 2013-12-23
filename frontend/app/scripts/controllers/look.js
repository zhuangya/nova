'use strict';

angular.module('frontendApp')
  .controller('LookCtrl', function ($scope, $http, $q, $compile) {

    var dribbbleShots = 'http://api.dribbble.com/shots/everyone?callback=JSON_CALLBACK&per_page=20';
    //var dribbbleShots = 'http://api.dribbble.com/players/simplebits/shots?callback=JSON_CALLBACK';

    var shotTemplate = '<div width="<%=wfWidth%>" height="<%=wfHeight%>" id="dribbble-<%=id%>" class="shot"><a href="<%=url%>"><img width="<%=wfWidth%>" height="<%=wfHeight%>" src="<%=image_url%>"></a></div>';

    var tailPosition = [0, 0, 0, 0];

    function dispatchShot(html, tailPosition, target) {
      target = target || $('#waterfall');
      var tempEl = $(html);
      var pos = tailPosition.indexOf(_.min(tailPosition));

      target.append(tempEl);

      tempEl.width('235px');


      tempEl.css({
        left: pos * 25 + '%',
        top: tailPosition[pos]
      });

      tailPosition[pos] += tempEl.outerHeight();

      console.log(tailPosition);

    }

    $http.jsonp(dribbbleShots).success(function(resp) {
      $scope.shots = resp.shots;
      _.each(resp.shots, function(shot) {
        console.log(shot);
        shot.wfWidth = '235px';
        shot.wfHeight = Math.ceil(235 / shot.width * shot.height) + 'px';

        var html = _.template(shotTemplate, shot);
        dispatchShot(html, tailPosition);
      });
    });
  });
