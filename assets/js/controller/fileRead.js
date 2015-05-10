angular.module('vidatio').controller('FileReadCtrl',
  ["$scope", "$http", "FileReaderService", "DataTableService",
    function ($scope, $http, FileReaderService, DataTable) {
      $scope.link = "http://www.wolfsberg.at/fileadmin/user_upload/Downloads/Haushalt2015.csv";
      $scope.progress = 0;

      console.log("fileread", FileReaderService);

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
      };

      // Read via Browsing and Drag-and-Drop
      $scope.getFile = function () {
        $scope.progress = 0;
        FileReaderService.readAsDataUrl($scope.file, $scope)
          .then(function (result) {
            DataTable.setDataset(result);
          });
      };

      $scope.$on("fileProgress", function (e, progress) {
        $scope.progress = progress.loaded / progress.total;
      });
    }
  ]
);