"use strict"

describe "Service Helper", ->
    beforeEach ->
        module "app"
        inject (HelperService, $injector) ->
            @injector = $injector
            @Helper = HelperService

    it "should remove null values of a two dimensional array", ->
        dataset = [
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

        expect(@Helper.trimDataset dataset).toEqual result

    it "should create a matrix with the initial value", ->
        dataset = [
            [
                "true", "true", "true"
            ]
            [
                "true", "true", "true"
            ]
            [
                "true", "true", "true"
            ]
        ]

        result = [
            [
                true, true, true
            ]
            [
                true, true, true
            ]
            [
                true, true, true
            ]
        ]

        expect(@Helper.createMatrix dataset, true).toEqual result

    it "should check if a value is a number", ->
        expect(@Helper.isNumber 3.14159).toBeTruthy()
        expect(@Helper.isNumber 180).toBeTruthy()
        expect(@Helper.isNumber -42).toBeTruthy()
        expect(@Helper.isNumber "Test").toBeFalsy()
        expect(@Helper.isNumber undefined).toBeFalsy()
        expect(@Helper.isNumber null).toBeFalsy()
        expect(@Helper.isNumber true).toBeFalsy()

    it "should cut the dataset by the specified amount of rows", ->
        @Helper.rowLimit = 2

        dataset = [
            [
                true, true, true
            ]
            [
                true, true, true
            ]
            [
                false, false, false
            ]
        ]

        result = [
            [
                true, true, true
            ]
            [
                true, true, true
            ]
        ]

        expect(@Helper.cutDataset dataset).toEqual result



