describe('Service', function () {
  describe('FileReader', function () {
    var content, rootScope, DataTable, FileReader;

    beforeEach(module('vidatio'));

    beforeEach(inject(function ($rootScope, $q, FileReaderService, DataTableService) {
      DataTable = DataTableService;
      FileReader = FileReaderService;
      rootScope = $rootScope.$new();

      //Initialize test file
      content = ["File test content"];
      var blob = new Blob(content, {type: 'text/html'});

      //Create promise and set it's return value
      var deferred = $q.defer();
      deferred.resolve(content);

      //Create FileReader Mock
      spyOn(FileReaderService, 'readAsDataUrl').and.returnValue(deferred.promise);

      //Use of FileReader mock
      FileReaderService.readAsDataUrl(blob).then(function (result) {
        DataTable.setDataset(result[0]);
      });
    }));

    it('should read data of the file', function () {
      //To resolve the promise
      rootScope.$digest();
      expect(DataTable.getDataset()[0]).toEqual(content);
    });

    it('should have progress updated', function () {
      FileReader.progress.loaded = 10;
      FileReader.progress.total = 10;
      expect(FileReader.getProgress()).toBe(1);

      FileReader.progress.loaded = 25;
      FileReader.progress.total = 50;
      expect(FileReader.getProgress()).toBe(0.5);
    });
  });
});
