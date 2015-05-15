/**
 * DESCRIPTION
 * User should be allowed to drop a file everywhere
 * so the file drop directive is splitted into to parts
 * the directive where it should start and the directive
 * on which element it should end
 */
angular.module('vidatio').directive("ngFileDropStart", function () {

  return {
    link: function ($scope, el) {
      //over: cursor currently moves over the drop-zone
      el.bind("dragover", function (e) {
        e.preventDefault();
        return false;
      });

      //enter: cursor enters the drop-zone
      el.bind("dragenter", function (e) {
        document.getElementsByClassName("drag-and-drop")[0].style.display = "block";
        e.preventDefault();
        return false;
      });
    }
  }
});
