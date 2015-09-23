"use strict"

describe "Service Helper", ->
    beforeEach ->
        module "app"
        inject (HelperService, $injector) ->
            @injector = $injector
            @Helper = HelperService

    it "should remove null values of a two dimensional array", ->
        array = [
            [
                null, null, null, null, null
            ]
            [
                null, "true", "false", null, null
            ]
            [
                null, "true", "false", null, null
            ]
            [
                null, null, null, null, null
            ]
        ]

        result = [
            [
                "true", "false"
            ]
            [
                "true", "false"
            ]
        ]

        expect(@Helper.trimDataset array).toEqual result

    it "should create a matrix with the initial value", ->



