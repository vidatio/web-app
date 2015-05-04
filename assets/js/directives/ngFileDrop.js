angular.module('vidatio').directive("ngFileDrop", function () {


  return {
    link: function ($scope, el) {
      //Drag-And-Drop Events:
      //leave: cursor moves out of drop-zone
      //over: cursor currently moves over the drop-zone
      //enter: cursor enters the drop-zone
      //drop: file got dropped on the drop-zone
      //drag, drag start and drag end isn't needed, because its only for DOM elements

      el.bind("dragover", function (e) {
        this.classList.add("drag-enter");
        e.preventDefault();
        return false;
      });
      el.bind("dragenter", function (e) {
        this.classList.add("drag-enter");
        e.preventDefault();
        return false;
      });
      el.bind("dragleave", function (e) {
        this.classList.remove("drag-enter");
        e.preventDefault();
        return false;
      });

      el.bind("drop", function (e) {
        e.preventDefault();

        $scope.file = e.dataTransfer.files[0];
        $scope.getFile();

        return false;
      });

    }
  }

})
