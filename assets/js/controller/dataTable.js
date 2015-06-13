angular.module('vidatio').controller("DataTableCtrl",
  ["$scope", "DataTableService", "MapService",
    function ($scope, DataTable) {
      $scope.rows = DataTable.dataset;
      $scope.colHeaders = true;
      $scope.minCols = 5;
      $scope.minRows = 5;
      $scope.autoColumnSize = true;
    }
  ]
);
