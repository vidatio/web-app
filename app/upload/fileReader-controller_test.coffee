# File-Reader Controller Test
# ====================

"use strict"

describe "Testing fileReader controller", ->
    describe "read file via browsing and drag & drop", ->

        FileReadCtrl = undefined
        scope = undefined
        rootScope = undefined

        beforeEach ->
            module "app"
            inject ($controller, $rootScope, $q, FileReader) ->
                scope = $rootScope.$new()
                rootScope = $rootScope

                FileReadCtrl = $controller "FileReadCtrl", $scope: scope

                deferred = $q.defer()
                deferred.resolve "aaa: 123; bbb:456"

                spyOn(FileReader, 'readAsDataUrl').and.returnValue(deferred.promise)

        it "should be present", ->
            expect( FileReadCtrl ).toBeDefined()

        it "should get the content of a file", ->
            scopeContent = [ 'aaa: 123; bbb: 456' ]
            #blob = new Blob(scopeContent, type: 'text/html')
            #scope.file = blob
            #scope.getFile()
            #rootScope.$apply()
            #expect(scope.content).toBe scopeContent[0]
        it 'should update the progress value', ->
            scope.$broadcast 'fileProgress',
                total: 10
                loaded: 10
            # expect(scope.progress).toBe 1

            scope.$broadcast 'fileProgress',
                total: 10
                loaded: 5
            # expect(scope.progress).toBe 0.5


    describe "read file via link", ->

        scope = undefined
        httpBackend = undefined

        beforeEach ->
            module "app"
            inject ($controller, $rootScope, $httpBackend) ->
                httpBackend = $httpBackend
                scope = $rootScope.$new()

                FileReadCtrl = $controller "FileReadCtrl", $scope: scope

        it 'should get the content of a file', ->
            httpBackend.whenGET('/v0/upload?url=test.txt').respond 'aaa: 123; bbb: 456'
            scope.link = 'test.txt'
            scope.load()
            # httpBackend.flush()
            # expect(scope.content).toBe 'aaa: 123; bbb: 456'
