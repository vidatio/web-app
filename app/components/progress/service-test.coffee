"use strict"


describe "Service Progress", ->
    beforeEach ->
        module "app"
        inject (ProgressOverlayService, $injector) ->
            @injector = $injector
            @overlay = ProgressOverlayService

    it "should be defined and included", ->
        expect(@overlay).toBeDefined()
        expect(@injector.has("ProgressOverlayService"))

    it "should be possible to set messages", ->
        @overlay.setMessage "This is a test!"
        expect(@overlay.getMessage()).toEqual "This is a test!"

    it "should be possible to reset messages", ->
        @overlay.setMessage("")
        expect(@overlay.getMessage()).toEqual ""
