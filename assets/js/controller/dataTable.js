angular.module('vidatio').controller("DataTableCtrl",
  ["$scope", "DataTableService",
    function ($scope, DataTable) {
      $scope.rows = DataTable.getDataset();
      DataTable.setDataset("Montag,5\nDienstag,2\nMittwoch,4");

      $scope.rowHeaders = true;
      $scope.colHeaders = true;
      $scope.minCols = 5;
      $scope.minRows = 5;
      $scope.autoColumnSize = true;
    }
  ]
);
