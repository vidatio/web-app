angular.module('vidatio').controller("MapCtrl",
  ["$scope", "DataTableService", "MapService",
    function ($scope, DataTable, Map) {

      //Default settings - Works like scope.center, etc.
      angular.extend($scope, {
        center: {
          lat: 47.723407,
          lng: 13.086921,
          zoom: 16
        }
      });

      Map.setMarkers(DataTable.dataset);
      $scope.markers = Map.markers;
    }
  ]
);

