"use strict"


describe "Service Progress", ->
    beforeEach ->
        module "app"
        inject (ProgressService, $injector, $timeout, $rootScope) ->
            @injector = $injector
            @progress = ProgressService
            @timeout = $timeout
            @rootScope = $rootScope

    it "should be defined and included", ->
        expect(@progress).toBeDefined()
        expect(@injector.has("ProgressService"))

    it "should be possible to set messages", ->
        @progress.setMessage "This is a test!"
        expect(@rootScope.progressMessage).toEqual "This is a test!"

    it "should be possible to reset messages", ->
        @progress.resetMessage()
        expect(@rootScope.progressMessage).toEqual ""
