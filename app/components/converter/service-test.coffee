"use strict"

describe "Service Converter", ->
    beforeEach ->
        module "app"
        inject (ConverterService, $injector, $q) ->
            @injector = $injector
            @Converter = ConverterService
            @deferred = $q.defer()

            spyOn(@Converter,'convertSHP2GeoJSON').and.returnValue(@deferred.promise)

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

    it 'should convert GeoJSON into arrays', ->
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

        result =
            [
                [
                    "Point",70,90
                ],
                [
                    "Point",80,80
                ],
                [
                    "Point",90,70
                ]
            ]

        expect(@Converter.convertGeoJSON2Arrays(geoJSON)).toEqual(result)

    it 'should extract Headers from GeoJSON', ->
        geoJSON =
        "type": "FeatureCollection"
        "features": [{
            "type": "Feature"
            "geometry":
                "type": "Point"
                "coordinates": [70,90]
            "properties":
                "prop0": "value0"
                "prop1": 0.0
            }, {
            "type": "Feature"
            "geometry":
                "type": "Polygon"
                "coordinates": [
                     [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0],
                       [100.0, 1.0], [100.0, 0.0] ]
                     ]
            "properties":
              "prop0": "value1"
              "prop1": 1.0
            }
        ]

        headers =
            [
                "prop0", "prop1", "type", "coordinates 0", "coordinates 1",
                "coordinates 2", "coordinates 3", "coordinates 4", "coordinates 5",
                "coordinates 6", "coordinates 7", "coordinates 8", "coordinates 9"
            ]

        expect(@Converter.convertGeoJSON2ColHeaders(geoJSON)).toEqual(headers)

