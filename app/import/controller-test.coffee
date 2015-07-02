# File-Reader Controller Test
# ====================

"use strict"

describe "Controller Import", ->
    describe "read file via link", ->
        scope = undefined
        rootScope = undefined

        beforeEach module('vidatio')
        beforeEach inject(($rootScope, $controller, $q, FileReader) ->
            scope = $rootScope.$new()
            rootScope = $rootScope
            $controller 'FileReadCtrl', $scope: scope
            deferred = $q.defer()
            deferred.resolve 'aaa: 123; bbb: 456'
            spyOn(FileReader, 'readAsDataUrl').and.returnValue deferred.promise
        )
        it 'should get the content of a file', ->
            scopeContent = ['aaa: 123; bbb: 456']
            blob = new Blob(scopeContent, type: 'text/html')
            scope.file = blob
            scope.getFile()
            rootScope.$apply()
            expect(scope.content).toBe scopeContent[0]

        it 'should update the progress value', ->
            scope.$broadcast 'fileProgress',
                total: 10
                loaded: 10
            expect(scope.progress).toBe 1

            scope.$broadcast 'fileProgress',
                total: 10
                loaded: 5
            expect(scope.progress).toBe 0.5

        describe 'read file via link', ->
            scope = undefined
            httpBackend = undefined
            beforeEach module('vidatio')
            beforeEach inject(($rootScope, $controller, $httpBackend) ->
                httpBackend = $httpBackend
                #create an empty scope
                scope = $rootScope.$new()
                #declare the controller and inject our empty scope
                $controller 'FileReadCtrl', $scope: scope
                return
            )
            it 'should get the content of a file', ->
                httpBackend.whenGET('/api?url=test.txt').respond 'aaa: 123; bbb: 456'
                scope.link = 'test.txt'
                scope.load()
                httpBackend.flush()
                expect(scope.content).toBe 'aaa: 123; bbb: 456'
