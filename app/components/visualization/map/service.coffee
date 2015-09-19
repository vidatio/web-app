# Map Service
# ===========

"use strict"

app = angular.module "app.services"

app.service 'MapService', [ ->
    class Map
        constructor: ->
            @map = undefined
            @geoJSON =
                "type": "FeatureCollection"
                "features": []
            @bounds = undefined

        # Because the map gets set later than the geoJSON
        # we need init function to do initial actions
        # like fitting to the bounds of the geoJSON
        init: ->
            @setBoundsToGeoJSON()

        setGeoJSON: (data) ->
            # safely remove all items, keeps data binding alive
            @geoJSON.features.splice 0, @geoJSON.features.length
            @geoJSON.features = data.features

            @setBoundsToGeoJSON()

        setBoundsToGeoJSON: ->
            if(!@geoJSON.features.length || !@map)
                return

            coordinates = []
            @geoJSON.features.forEach (feature) ->
                if feature.geometry.type == "Point"
                    latLng = L.GeoJSON.coordsToLatLng(feature.geometry.coordinates)
                    coordinates.push(latLng)
                else if feature.geometry.type == "LineString"
                    feature.geometry.coordinates.forEach (latLng) ->
                        latLng = L.GeoJSON.coordsToLatLng(latLng)
                        coordinates.push(latLng)

            @bounds = L.latLngBounds(coordinates)
            @map.fitBounds(@bounds)

    new Map
]
