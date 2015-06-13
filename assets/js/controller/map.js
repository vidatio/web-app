angular.module('vidatio').controller("MapCtrl",
  ["$scope", "DataTableService", "MapService",
    function ($scope, DataTable, Map) {

      // Default settings for the map
      angular.extend($scope, {
        center: {
          lat: 47.723407,
          lng: 13.086921,
          zoom: 16
        }
      });

      // Watch on the dataset from the data table
      // and update markers on changed data
      $scope.$watch(
        function () {
          return DataTable.dataset
        },
        function (dataset) {
          Map.setMarkers(dataset);
        }, true
      );

      $scope.markers = Map.markers;
    }
  ]
);

