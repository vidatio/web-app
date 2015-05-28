/**
 * DESCRIPTION
 * User should be allowed to drop a file everywhere
 * so the file drop directive is splitted into to parts
 * the directive where it should start and the directive
 * on which element it should end
 */

angular.module('vidatio').directive("ngFileDropEnd", function () {
  return {
    link: function ($scope, el) {
      //leave: cursor moves out of drop-zone
      el.bind("dragleave", function (e) {
        e.target.parentElement.style.display = "none";

        e.preventDefault();
        return false;
      }.bind(this));

      //over: cursor currently moves over the drop-zone
      el.bind("dragover", function (e) {
        e.preventDefault();
        return false;
      });

      //drop: file got dropped on the drop-zone
      el.bind("drop", function (e) {
        e.target.parentElement.style.display = "none";

        $scope.file = e.dataTransfer.files[0];
        $scope.getFile();

        e.preventDefault();
        return false;
      });
    }
  }
});
