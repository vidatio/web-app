
"use strict"

describe "testing app modules: ", ->

    app_module = undefined
    deps = undefined

    hasModule = ( module_name ) ->
        return deps.indexOf( module_name ) >= 0

    describe "testing app module dependencies", ->

        beforeEach ->
            app_module = angular.module "animals"
            deps = app_module.value( "animals" ).requires


        it "should be registered", ->
            expect( app_module ).toBeDefined()

        it "should have a registered 'ngRoute' dependency", ->
            expect( hasModule("ngRoute") ).toBeTruthy()

        it "should have a registered 'ngAnimate' dependency", ->
            expect( hasModule("ngAnimate") ).toBeTruthy()

        it "should have a registered 'ngResource' dependency", ->
            expect( hasModule("ngResource") ).toBeTruthy()

        it "should have a registered 'ui.bootstrap' dependency", ->
            expect( hasModule("ui.bootstrap") ).toBeTruthy()

        it "should have a registered 'animals.controllers' dependency", ->
            expect( hasModule("animals.controllers") ).toBeTruthy()

        it "should have a registered 'animals.services' dependency", ->
            expect( hasModule("animals.services") ).toBeTruthy()

        it "should have a registered 'animals.directives' dependency", ->
            expect( hasModule("animals.directives") ).toBeTruthy()

