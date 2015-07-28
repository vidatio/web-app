describe "Service Map", ->
    beforeEach ->
        module "app"
        inject (MapService, $injector) ->
            @injector = $injector
            @Map = MapService

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
