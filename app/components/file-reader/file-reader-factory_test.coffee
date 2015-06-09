# File Reader Service Test
# =================

"use strict"

describe "file reader service", ->
    describe "read file via browsing and drag & drop", ->
        FileReadCtrl = undefined
        scope = undefined
        rootScope = undefined
        _FileReader = undefined

        beforeEach ->
            module "app"
            inject ($controller, $rootScope, $q, FileReader) ->
                scope = $rootScope.$new()
                rootScope = $rootScope
                _FileReader = FileReader

                FileReadCtrl = $controller "FileReadCtrl", $scope: scope

                deferred = $q.defer()
                deferred.resolve "aaa: 123; bbb:456"

                spyOn(FileReader, 'readAsDataUrl').and.returnValue(deferred.promise);

        it "should be present", ->
            expect(FileReadCtrl).toBeDefined()

        it "should get the content of a file", ->
            fileContent = ['aaa: 123; bbb: 456']

            builder = new WebKitBlobBuilder()
            builder.append(fileContent)
            blob = builder.getBlob()

    #scope.file = blob
    #scope.getFile()
    #rootScope.$apply()
    #expect(scope.content).toBe fileContent[0]
