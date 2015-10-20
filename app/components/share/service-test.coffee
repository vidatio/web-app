"use strict"

describe "Service Share", ->
    beforeEach ->
        module "app"
        inject (ShareService, $injector, $q, $rootScope,  $httpBackend) ->
            @injector = $injector
            @Share = ShareService
            @deferred = $q.defer()
            @rootScope = $rootScope
            @httpBackend = $httpBackend

            #spyOn(@Share, "mapToImg").and.returnValue(@deferred.promise);

    it "should be defined", ->
        expect(@Share).toBeDefined()

    it "should simulate promises", ->
        @httpBackend.whenGET(/index/).respond ""
        @httpBackend.expectGET(/languages/).respond ""
        promise = @deferred.promise
        resolvedValue = undefined

        promise.then (val) ->
            resolvedValue = val

        expect(resolvedValue).toBeUndefined()

        @deferred.resolve "test"

        expect(resolvedValue).toBeUndefined()

        @rootScope.$apply()
        expect(resolvedValue).toEqual("test")

    it "should resolve promise", ->
