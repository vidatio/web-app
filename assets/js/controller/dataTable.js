angular.module('vidatio').controller("DataTableCtrl",
  ["$scope", "DataTableService",
    function ($scope, DataTable) {
      $scope.rows = DataTable.dataset;
      DataTable.setDataset("Montag,5\nDienstag,2\nMittwoch,4");

      $scope.colHeaders = true;
      $scope.rowHeaders = true;
      $scope.minCols = 26;
      $scope.minRows = 26;
      $scope.autoColumnSize = true;
      $scope.currentColClassName = "current-col";
    }
  ]
);
