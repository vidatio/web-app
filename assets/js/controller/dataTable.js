angular.module('vidatio').controller('DataTableCtrl', function ($scope, $rootScope, DataTable) {
  var table;

  //Initial receiving the handsontable instance
  $scope.afterInit = function () {
    table = this;
  };

  //Event gets fired from the DataTable service, when the dataset has been changed by the user
  $rootScope.$on("datasetChanged", function (e) {
    //Because watch on model rows doesn't work, we have to call the function loadData
    //Table have to be a variable on scope, because else we can't access
    $scope.rows = DataTable.getDataset();
    table.loadData($scope.rows);
  });

  $scope.rowHeaders = true;
  $scope.colHeaders = true;
  $scope.minCols = 5;
  $scope.minRows = 5;
  $scope.autoColumnSize = true;
});
