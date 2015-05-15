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
        e.preventDefault();
        return false;
      });
      el.bind("dragenter", function (e) {
        document.getElementsByClassName("drag-and-drop")[0].style.display = "block";
        e.preventDefault();
        return false;
      });

      //Because the user which is dragging a file enters the body
      //but instantly moving around or leaving the drag-and-drop area
      //we have to bind the events to this drag-and-drop area
      var dragDropArea = document.getElementsByClassName("drag-and-drop")[0];
      dragDropArea.addEventListener("dragleave", function (e) {
        dragDropArea.style.display = "none";
        e.preventDefault();
        return false;
      }, false);

      dragDropArea.addEventListener("dragover", function (e) {
        e.preventDefault();
        return false;
      }, false);

      dragDropArea.addEventListener("drop", function (e) {
        dragDropArea.style.display = "none";

        $scope.file = e.dataTransfer.files[0];
        $scope.getFile();

        e.preventDefault();
        return false;
      }, false);
    }
  }
});
