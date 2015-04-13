angular.module('vidatio').controller('FileUploadCtrl', function ($scope, $http, FileReader) {

    $scope.getFile = function () {
        $scope.progress = 0;
        FileReader.readAsDataUrl($scope.file, $scope)
                      .then(function(result) {
                          $scope.content = result;
                      });
    };
 
    $scope.$on("fileProgress", function(e, progress) {
        $scope.progress = progress.loaded / progress.total;
    });

    $scope.getUrl = function() {
      var url = "http://www.wolfsberg.at/fileadmin/user_upload/Downloads/Haushalt2015.csv";

      $http.jsonp(url)
          .success(function(data){
              console.log(data.found);
          });
      // // Simple GET request example :
      // $http.get('http://www.wolfsberg.at/fileadmin/user_upload/Downloads/Haushalt2015.csv').
      //   success(function(data, status, headers, config) {
      //     // this callback will be called asynchronously
      //     // when the response is available
      //     console.log("success url");
      //     console.log(data);
      //     console.log(status);          
      //   }).
      //   error(function(data, status, headers, config) {
      //     // called asynchronously if an error occurs
      //     // or server returns response with an error status.
      //     console.log("error url");

      //   });
    };
 
});