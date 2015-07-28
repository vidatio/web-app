"use strict"

describe "Service Converter", ->
    beforeEach ->
        module "app"
        inject (ConverterService, $injector) ->
            @injector = $injector
            @Converter = ConverterService

    it 'should be defined and included', ->
        expect(@Converter).toBeDefined()
        expect(@injector.has("ConverterService"))

    it 'checks if a value is a coordinate', ->
        expect(@Converter.isCoordinate(-360, -180)).toBeFalsy()
        expect(@Converter.isCoordinate(-180, -180)).toBeFalsy()
        expect(@Converter.isCoordinate("test", 90)).toBeFalsy()
        expect(@Converter.isCoordinate(90, 90)).toBeTruthy()
        expect(@Converter.isCoordinate(-90, -180)).toBeTruthy()

    it 'should convert arrays into geoJSON', ->
        dataset = [["90", "70"], ["80", "80"], ["70", "90"]]
        geoJSON =
            "type": "FeatureCollection"
            "features": [{
                "type": "Feature"
                "geometry":
                    "type": "Point"
                    "coordinates": [70,90]
                }, {
                "type": "Feature"
                "geometry":
                    "type": "Point"
                    "coordinates": [80,80]
                }, {
                "type": "Feature"
                "geometry":
                    "type": "Point"
                    "coordinates": [90,70]
                }
            ]
        expect(@Converter.convertArrays2GeoJSON(dataset)).toEqual(geoJSON)

    it 'should convert csv into arrays', ->
        csv = "90,180,description0\n90,-90,description1"
        expect(@Converter.convertCSV2Arrays(csv)).toEqual([["90", "180", "description0"], ["90", "-90", "description1"]])
