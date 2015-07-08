describe('Service', function () {
  describe('FileReader', function () {
    var fileContent, scope, DataTable, FileReader;

    beforeEach(module('vidatio'));

    beforeEach(inject(function ($rootScope, $q, FileReaderService, DataTableService) {
      DataTable = DataTableService;
      FileReader = FileReaderService;
      scope = $rootScope.$new();

      //Initialize test file
      fileContent = ["File test content"];
      var blob = new Blob(fileContent, {type: 'text/html'});

      //Create promise and set it's return value
      var deferred = $q.defer();
      deferred.resolve(fileContent);

      //Create FileReader Mock
      spyOn(FileReaderService, 'readFile').and.returnValue(deferred.promise);

      //Use of FileReader mock
      FileReaderService.readFile(blob).then(function (result) {
        DataTable.setDataset(result[0]);
      });
    }));

    it('should read data of the file', function () {
      //To resolve the promise
      scope.$digest();
      expect(DataTable.dataset[0]).toEqual(fileContent);
    });

    it('should have progress updated', function () {
      FileReader.progress = 1;
      expect(FileReader.progress).toBe(1);

      FileReader.progress = 0.5;
      expect(FileReader.progress).toBe(0.5);
    });
  });
});
