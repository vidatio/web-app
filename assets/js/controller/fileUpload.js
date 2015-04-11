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
});