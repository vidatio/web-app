describe('Service', function () {
  describe('DataTable', function () {
    var scope, rootScope, dataset, result, DataTable;

    beforeEach(module('vidatio'));

    beforeEach(inject(function ($rootScope, _DataTable_) {
      //create an empty scope
      scope = $rootScope.$new();
      rootScope = $rootScope;

      spyOn(rootScope, '$broadcast');

      DataTable = _DataTable_;

      // //initialize dataset and result
      dataset = "Montag,5\nDienstag,2\nMittwoch,4";
      result = [['Montag','5'],['Dienstag','2'],['Mittwoch','4']];
    }));

    it('should convert dataset to array and fire event "datasetChanged"', function () {
      DataTable.setDataset(dataset);
      expect(rootScope.$broadcast).toHaveBeenCalledWith('datasetChanged');
      expect(DataTable.getDataset()).toEqual(result);
    });

  });
});
