describe('Service', function () {
  describe('DataTable', function () {
    var input, output, DataTable;

    beforeEach(module('vidatio'));

    beforeEach(inject(function ($rootScope, DataTableService) {
      DataTable = DataTableService;

      input = "Montag,5\nDienstag,2\nMittwoch,4";
      output = [['Montag','5'],['Dienstag','2'],['Mittwoch','4']];
    }));

    it('should convert dataset to array', function () {
      DataTable.setDataset(dataset);
      expect(DataTable.getDataset()).toEqual(output);
    });

  });
});
