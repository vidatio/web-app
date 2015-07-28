# Map Service
# ======================

"use strict"

app = angular.module "app.services"

app.service 'MapService', [ ->
    class Map
        constructor: ->
            @geoJSON = {
                "type": "FeatureCollection",
                "features": []
            }

        setGeoJSON: (data) ->
            # safely remove all items, keeps data binding alive
            @geoJSON.features.splice 0, @geoJSON.features.length
            @geoJSON.features = data.features


    new Map
]
