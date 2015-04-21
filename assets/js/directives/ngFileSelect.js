angular.module('vidatio').directive("ngFileSelect",function(){

  return {
    link: function($scope,el){
      el.bind("change", function(e){
        console.log('file select change');
        $scope.file = (e.srcElement || e.target).files[0];
        $scope.getFile();
      })
    }
  }
  
})
