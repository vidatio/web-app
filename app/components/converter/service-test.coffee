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

    xit 'should convert shp into arrays', ->
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
                    "Point","70","90"
                ],
                [
                    "Point","70","90"
                ],
                [
                    "Point","90","70"
                ]
            ]

        @deferred.resolve(geoJSON)
        expect(@Converter.convertSHP2GeoJSON(geoJSON)).toEqual(result)
