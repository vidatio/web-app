angular.module('vidatio').controller('FileUploadCtrl', function ($scope, $http) {
  $scope.link = "http://www.wolfsberg.at/fileadmin/user_upload/Downloads/Haushalt2015.csv";

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

  $scope.getFile = function () {
    $scope.progress = 0;
    FileReader.readAsDataUrl($scope.file, $scope)
      .then(function (result) {
        $scope.content = result;
      });
  };

  $scope.$on("fileProgress", function (e, progress) {
    $scope.progress = progress.loaded / progress.total;
  });

  $scope.getUrl = function () {
    var url = "http://www.wolfsberg.at/fileadmin/user_upload/Downloads/Haushalt2015.csv";

    $http.jsonp(url)
      .success(function (data) {
        console.log(data.found);
      });
  };
});