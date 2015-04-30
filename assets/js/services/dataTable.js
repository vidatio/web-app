angular.module('vidatio').service('DataTable', function ($rootScope) {
  var dataset;

  var setDataset = function(data){
    var result = [];
    var rows = data.split("\n");
    rows.forEach(function(element,index,array){
      var row = [];
      var columns = element.split(",");
      columns.forEach(function(element, index, array){
        row[index] = element;
      });
      result.push(row);
    });

    dataset = result;
    $rootScope.$broadcast("datasetChanged");
  };

  var getDataset = function(){
    return dataset;
  };

  return {
    setDataset: setDataset,
    getDataset: getDataset
  }
});
