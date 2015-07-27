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
            @featureTemplate = {
                "type": "Feature"
                "geometry": {
                    "type": undefined
                    "coordinates": []
                }
            }

        isCoordinate: (lat, lng) ->
            lat == Number(lat) and lat >= -90 and lat <= 90 &&
                lng == Number(lng) and lng >= -180 and lng <= 180

        ### @param data: 2D array with latitude and longitude ###
        setGeoJSON: (data) ->
            # safely remove all items, keeps data binding alive
            @geoJSON.features.splice 0, @geoJSON.features.length

            # update markers
            length = 0
            data.forEach (element) =>
                lat = parseFloat(element[0])
                lng = parseFloat(element[1])
                if @isCoordinate(lat, lng)
                    feature = JSON.parse(JSON.stringify(@featureTemplate))
                    feature.geometry.coordinates = [parseFloat(lng), parseFloat(lat)]
                    feature.geometry.type = "Point"
                    @geoJSON.features.push(feature)

    new Map
]
