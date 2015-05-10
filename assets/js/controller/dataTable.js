angular.module('vidatio').controller("DataTableCtrl",
  ["$scope", "DataTableService",
    function ($scope, DataTable) {
      $scope.table;

      //Initial receiving the handsontable instance
      $scope.afterInit = function () {
        $scope.table = this;
        $scope.table.loadData($scope.rows);
      };

      $scope.rows = DataTable.dataset;
      DataTable.setDataset("Montag,5\nDienstag,2\nMittwoch,4");

      $scope.rowHeaders = true;
      $scope.colHeaders = true;
      $scope.minCols = 5;
      $scope.minRows = 5;
      $scope.autoColumnSize = true;
    }
  ]
);