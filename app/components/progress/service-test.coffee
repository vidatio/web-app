"use strict"


describe "Service Progress", ->
    beforeEach ->
        module "app"
        inject (ProgressService, $injector, $timeout) ->
            @injector = $injector
            @progress = ProgressService
            @timeout = $timeout

    it "should be defined and included", ->
        expect(@progress).toBeDefined()
        expect(@injector.has("ProgressService"))

    it "should be possible to set messages", ->
        @progress.setMessage "This is a test!"
        @timeout ->
            expect(@progress.getMessage()).toEqual "This is a test!"

    it "should be possible to reset messages", ->
        @progress.setMessage("")
        expect(@progress.getMessage()).toEqual ""