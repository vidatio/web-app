"use strict"

describe "Service Converter", ->
    beforeEach ->
        module "app"
        inject (ConverterService, $injector, $q) ->
            @injector = $injector
            @Converter = ConverterService
            @deferred = $q.defer()
            spyOn(@Converter, 'convertSHP2GeoJSON').and.returnValue(@deferred.promise)

    it 'should be defined and included', ->
        expect(@Converter).toBeDefined()
        expect(@injector.has("ConverterService"))

    it 'should convert arrays to geoJSON', ->
        dataset = [["90", "70"], ["80", "80"], ["70", "90"]]
        geoJSON =
            "type": "FeatureCollection"
            "features": [{
                "type": "Feature"
                "geometry":
                    "type": "Point"
                    "coordinates": [90, 70]
                "properties": {}
            }, {
                "type": "Feature"
                "geometry":
                    "type": "Point"
                    "coordinates": [80, 80]
                "properties": {}
            }, {
                "type": "Feature"
                "geometry":
                    "type": "Point"
                    "coordinates": [70, 90]
                "properties": {}
            }
            ]
        expect(@Converter.convertArrays2GeoJSON(dataset)).toEqual(geoJSON)

        dataset = [
            ["City", "Content", "GEOMETRIE"]
            ["Innsbruck", "40,5%", "POINT (49 11)"]
            ["Salzburg", "41,5%", "POINT (49 12)"]
            ["Innsbruck", "42,5%", "POINT (49 13)"]
        ]

        geoJSON =
            "type": "FeatureCollection"
            "features": [{
                "type": "Feature"
                "geometry":
                    "type": "Point"
                    "coordinates": [11, 49]
                "properties": {
                    0: "Innsbruck"
                    1: "40,5%"
                }
            }, {
                "type": "Feature"
                "geometry":
                    "type": "Point"
                    "coordinates": [12, 49]
                "properties": {
                    0: "Salzburg"
                    1: "41,5%"
                }
            }, {
                "type": "Feature"
                "geometry":
                    "type": "Point"
                    "coordinates": [13, 49]
                "properties": {
                    0: "Innsbruck"
                    1: "42,5%"
                }
            }
            ]
        expect(@Converter.convertArrays2GeoJSON(dataset)).toEqual(geoJSON)

    xit 'should convert shp into arrays', ->
        geoJSON =
            "type": "FeatureCollection"
        "features": [{
            "type": "Feature"
            "geometry":
                "type": "Point"
                "coordinates": [70, 90]
        }, {
            "type": "Feature"
            "geometry":
                "type": "Point"
                "coordinates": [80, 80]
        }, {
            "type": "Feature"
            "geometry":
                "type": "Point"
                "coordinates": [90, 70]
        }
        ]

        result =
            [
                [
                    "Point", "70", "90"
                ],
                [
                    "Point", "70", "90"
                ],
                [
                    "Point", "90", "70"
                ]
            ]

        @deferred.resolve(geoJSON)
        expect(@Converter.convertSHP2GeoJSON(geoJSON)).toEqual(result)
