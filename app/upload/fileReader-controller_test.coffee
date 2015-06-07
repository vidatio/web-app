# File-Reader Controller Test
# ====================

"use strict"

describe "Testing fileReader controller", ->

    describe "read file via link", ->

        scope = undefined
        httpBackend = undefined

        beforeEach ->
            module "app"
            inject ($controller, $rootScope, $httpBackend) ->
                httpBackend = $httpBackend
                scope = $rootScope.$new()
                FileReadCtrl = $controller "FileReadCtrl", $scope: scop

        it 'should get the content of a file', ->
            httpBackend.whenGET('/v0/upload?url=test.txt').respond 'aaa: 123; bbb: 456'
            scope.link = 'test.txt'
            console.log("0");
            scope.load()
            console.log("1");
            httpBackend.flush()
            console.log("2");
            # expect(scope.content).toBe 'aaa: 123; bbb: 456'
