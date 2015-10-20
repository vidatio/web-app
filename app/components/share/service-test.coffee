"use strict"

describe "Service Share", ->
    beforeEach ->
        module "app"
        inject (ShareService, $injector) ->
            @injector = $injector
            @Share = ShareService

    it "should be defined", ->
        expect(@Share).toBeDefined()
        expect(@injector.has("ShareService"))
