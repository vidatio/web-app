angular.module('vidatio').controller("DataTableCtrl",
  ["$scope", "DataTableService",
    function ($scope, DataTable) {
      $scope.rows = DataTable.dataset;
      DataTable.setDataset("47.723955,13.084850\n47.725081,13.087736\n47.724881,13.086685\n47.724186,13.086181\n47.722308,13.086172\n47.722749,13.089662");

      $scope.colHeaders = true;
      $scope.minCols = 5;
      $scope.minRows = 5;
      $scope.autoColumnSize = true;
    }
  ]
);
