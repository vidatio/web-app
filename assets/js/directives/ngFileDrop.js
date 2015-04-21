angular.module('vidatio').directive("ngFileDrop",function(){


  return {
    link: function($scope,el){
    
      var preventDefault = function(e){
      	e.preventDefault();
      	return false;
      };

      el.bind("drag", preventDefault);	
      el.bind("dragstart", preventDefault);
      el.bind("dragend", preventDefault);
      el.bind("dragover", preventDefault);
      el.bind("dragenter", preventDefault);
      el.bind("dragleave", preventDefault);
      
      el.bind("drop", function(e){
      	console.log("file droped");
      	e.preventDefault();

        $scope.file = e.dataTransfer.files[0];
        $scope.getFile();
        return false;
      });

    }
  }
  
})