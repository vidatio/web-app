angular.module('vidatio').controller('FileUploadCtrl', function ($scope, $upload) {

  // Watch if the model "files" gets changed
  // Happens when the user is uploading a file
  $scope.$watch('files', function () {
    $scope.upload($scope.files);
  });

  // Callback for every file which have to be uploaded
  $scope.upload = function (files) {
    if (files && files.length) {
      for (var i = 0; i < files.length; i++) {
        var file = files[i];

        $upload.progress(function (evt) {
          var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
          console.log('progress: ' + progressPercentage + '% ' + evt.config.file.name);
        }).success(function (data, status, headers, config) {
          console.log('file ' + config.file.name + 'uploaded. Response: ' + data);
        });

      }
    }
  };

  // Config and fill table
  $scope.colHeaders = true;
  $scope.db = {};
  $scope.db.items = [
    {
      hours: 4
    },
    {
      hours: 8
    }
  ];

  $scope.db.dynamicColumns = [{
    data: 'hours',
    title: 'Hours worked per day'
  }];

});