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

        console.log(file.blob);

        $upload.upload({
          url: 'upload/url',
          file: file
        }).progress(function (evt) {
          var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
          console.log('progress: ' + progressPercentage + '% ' + evt.config.file.name);
        }).success(function (data, status, headers, config) {
          console.log('file ' + config.file.name + 'uploaded. Response: ' + data);
        });

      }
    }
  };

  // Config and fill table

  $scope.db = {};
  $scope.db.items = [
    {
      col1: "row1col1",
      col2: "row1col2",
      col3: "row1col3"
    },
    {
      col1: "row2col1",
      col2: "row2col2",
      col3: "row2col3"
    }
  ];

  $scope.db.dynamicColumns = [
    {
      data: 'col1',
      title: 'COL1'
    },
    {
      data: 'col2',
      title: 'COL2'
    },
    {
      data: 'col3',
      title: 'COL3'
    }
  ];

});