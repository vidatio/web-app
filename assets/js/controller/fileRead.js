angular.module('vidatio').controller('FileReadCtrl',
  ["$scope", "$http", "FileReaderService", "DataTableService",
    function ($scope, $http, FileReader, DataTable) {

      $scope.link = "http://www.wolfsberg.at/fileadmin/user_upload/Downloads/Haushalt2015.csv";
      $scope.progress = FileReader.progress;

      // Read via link
      $scope.load = function () {
        var url = $scope.link;
        $http.get("/api", {
          params: {
            url: url
          }
        })
          .success(function (data) {
            DataTable.setDataset(data);
          });
      };

      // Read via Browsing and Drag-and-Drop
      $scope.getFile = function () {
        FileReader.readAsDataUrl($scope.file, $scope)
          .then(function (result) {
            DataTable.setDataset(result);
          });
      };
    }
  ]
);
