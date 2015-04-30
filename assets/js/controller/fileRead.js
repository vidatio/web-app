angular.module('vidatio').controller('FileReadCtrl', function ($scope, $http, FileReader, DataTable) {
  $scope.link = "http://www.wolfsberg.at/fileadmin/user_upload/Downloads/Haushalt2015.csv";
  $scope.progress = 0;

  // Read via link
  $scope.load = function () {
    var url = $scope.link;
    $http.get("/api", {
        params: {
          url: url
        }
      })
      .success(function (data) {
        $scope.content = data;
      });
  }

  // Read via Browsing and Drag-and-Drop
  $scope.getFile = function () {
    $scope.progress = 0;
    FileReader.readAsDataUrl($scope.file, $scope)
      .then(function (result) {
        DataTable.setDataset(result);
      });
  };

  $scope.$on("fileProgress", function (e, progress) {
    $scope.progress = progress.loaded / progress.total;
  });
});
