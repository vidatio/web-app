# Map Service
# ======================

"use strict"

app = angular.module "app.services"

app.service 'MapService', [ ->
    class Map
        constructor: ->
            @geoJSON =
                "type": "FeatureCollection"
                "features": []

        setGeoJSON: (data) ->
            # safely remove all items, keeps data binding alive
            @geoJSON.features.splice 0, @geoJSON.features.length
            @geoJSON.features = data.features

        isNumeric: (n) ->
            return (!isNaN(parseFloat(n)) && isFinite(n))

        updateGeoJSONwithSHP: (row, column, oldData, newData, key) ->
            # This function updates the geoJSON after table changes
            keys = key.split(" ")

            if keys[0] == "coordinates"
                if @isNumeric(newData)
                    if @geoJSON.features[row].geometry.type == "Point"
                        @geoJSON.features[row].geometry.coordinates[keys[1]] = newData
                    if @geoJSON.features[row].geometry.type == "Polygon"
                        arrayIndex = Math.floor(keys[1] / 2)
                        index = keys[1] % 2
                        if Array.isArray(@geoJSON.features[row].geometry.coordinates[0][arrayIndex])
                            @geoJSON.features[row].geometry.coordinates[0][arrayIndex][index] = newData
                        else
                            # Array does not exist and can't be updated
                            console.log "Array does not exist and can't be updated"
                            # The table has to be reseted if the array can't be updated
                            return false
                else
                    console.log "Value is not a Number"
                    return false

            else if keys[0] == "bbox"
                if @isNumeric(newData)
                    @geoJSON.features[row].geometry.bbox[keys[1]] = newData
                else
                    console.log "Value is not a Number"
                    return false

            # check if colHeader is part of properties
            else
                for property, value of @geoJSON.features[row].properties
                    if key == property
                        @geoJSON.features[row].properties[key] = newData

            return true

        getGeoJSON: ->
            return @geoJSON

    new Map
]
