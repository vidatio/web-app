describe "Service Map", ->
    beforeEach ->
        module "app"
        inject (MapService, $injector, $rootScope) ->
            @scope = $rootScope.$new()
            @injector = $injector

            @Map = MapService
            @Map.init @scope

    it 'should be defined and included', ->
        expect(@Map).toBeDefined()
        expect(@injector.has("MapService"))

    it 'should have a geoJSON object', ->
        expect(@Map.geoJSON).toBeDefined()
        expect(@Map.geoJSON.type).toEqual("FeatureCollection")
        expect(@Map.geoJSON.features).toEqual([])

    it "shouldn't replace the geoJSON object complete", ->
        geoJSON =
            "type": "FeatureCollection"
            "features": [
                {
                    "type": "Point"
                    "geometry": [10,20]
                },
                {
                    "type": "Point"
                    "geometry": [20,10]
                }
            ]

        @Map.setGeoJSON(geoJSON)
        expect(@Map.geoJSON).toEqual(geoJSON)

        @Map.setGeoJSON(
            "features": []
        )

        expect(@Map.geoJSON).toEqual(
            "type": "FeatureCollection"
            "features": []
        )

    describe "should update the geoJSON object (generated from shp)", ->
        geoJSON =
            "type": "FeatureCollection"
            "features": [
                {
                    "geometry": {
                        "type": "Point"
                        "coordinates": [10,20]
                    }
                    "properties": {
                        "prop0": "value0",
                        "prop1": 0.0
                    }
                },
                {
                    "geometry": {
                        "type": "Point"
                        "coordinates": [20,10]
                    }
                }
            ]

        it "with a new coordinate", ->
            updatedGeoJSON =
                "type": "FeatureCollection"
                "features": [
                    {
                        "geometry": {
                            "type": "Point"
                            "coordinates": [10,99]
                        }
                        "properties": {
                            "prop0": "value0",
                            "prop1": 0.0
                        }
                    },
                    {
                        "geometry": {
                            "type": "Point"
                            "coordinates": [20,10]
                        }
                    }
                ]

            @Map.setGeoJSON(geoJSON)
            expect(@Map.geoJSON).toEqual(geoJSON)

            expect(@Map.updateGeoJSONWithSHP(0, 0, 20, 99, "coordinates 1")).toEqual(true)
            expect(@Map.geoJSON).toEqual(updatedGeoJSON)

        it "with a new property", ->
            updatedGeoJSON =
                "type": "FeatureCollection"
                "features": [
                    {
                        "geometry": {
                            "type": "Point"
                            "coordinates": [10,99]
                        }
                        "properties": {
                            "prop0": "newValue",
                            "prop1": 0.0
                        }
                    },
                    {
                        "geometry": {
                            "type": "Point"
                            "coordinates": [20,10]
                        }
                    }
                ]

            @Map.setGeoJSON(geoJSON)
            expect(@Map.geoJSON).toEqual(geoJSON)

            expect(@Map.updateGeoJSONWithSHP(0, 0, "value0", "newValue", "prop0")).toEqual(true)
            expect(@Map.geoJSON).toEqual(updatedGeoJSON)

    describe "should not update the geoJSON object (generated from shp)", ->
        geoJSON =
            "type": "FeatureCollection"
            "features": [
                {
                    "geometry": {
                        "type": "Point"
                        "coordinates": [10,20]
                    }
                },
                {
                    "geometry": {
                        "type": "Polygon"
                        "coordinates": [[20,10], [30,20], [40,30]]
                    }
                }
            ]

        it "with a non numeric value for coordinates", ->
            @Map.setGeoJSON(geoJSON)
            expect(@Map.geoJSON).toEqual(geoJSON)

            expect(@Map.updateGeoJSONWithSHP(0, 0, 10, "NAN", "coordinates 0")).toEqual(false)

        it "with a non existing point", ->
            @Map.setGeoJSON(geoJSON)
            expect(@Map.geoJSON).toEqual(geoJSON)

            expect(@Map.updateGeoJSONWithSHP(1, 1, 10, 99, "coordinates 99")).toEqual(false)

        it "with a non existing polygon", ->
            @Map.setGeoJSON(geoJSON)
            expect(@Map.geoJSON).toEqual(geoJSON)

            expect(@Map.updateGeoJSONWithSHP(1, 5, 10, 99, "coordinates 99")).toEqual(false)

