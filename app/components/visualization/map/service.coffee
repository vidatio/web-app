# Map Service
# ===========

"use strict"

app = angular.module "app.services"

app.service 'MapService', [
    "ParserService"
    "HelperService"
    (Parser, Helper) ->
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
                @resizeMap()

            resetGeoJSON: ->
                @geoJSON =
                    "type": "FeatureCollection"
                    "features": []

            # @method setGeoJSON
            # @description sets new geoJSON data, which automatically updates the map.
            # @param {geoJSON} data
            setGeoJSON: (data) ->
                # safely remove all items, keeps data binding alive
                @geoJSON.features.splice 0, @geoJSON.features.length
                @geoJSON.features = data.features

                @setBoundsToGeoJSON()

            # Notifies the leaflet map to resize itself
            # @method resizeMap
            # @public
            resizeMap: ->
                if(@map)
                    @map.invalidateSize()

            setBoundsToGeoJSON: ->
                if(!@geoJSON.features.length || !@map)
                    return

                coordinates = []
                @geoJSON.features.forEach (feature) ->

                    if feature.geometry.type is "Point"
                        if Parser.isCoordinate(feature.geometry.coordinates[0]) and Parser.isCoordinate(feature.geometry.coordinates[1])
                            latLng = L.GeoJSON.coordsToLatLng(feature.geometry.coordinates)
                            coordinates.push(latLng)
                    else if feature.geometry.type is "LineString"
                        feature.geometry.coordinates.forEach (latLng) ->
                            if Parser.isCoordinate(latLng[0]) and Parser.isCoordinate(latLng[1])
                                latLng = L.GeoJSON.coordsToLatLng(latLng)
                                coordinates.push(latLng)
                    else if feature.geometry.type is "Polygon"
                        feature.geometry.coordinates[0].forEach (latLng) ->
                            if Parser.isCoordinate(latLng[0]) and Parser.isCoordinate(latLng[1])
                                latLng = L.GeoJSON.coordsToLatLng(latLng)
                                coordinates.push(latLng)
                    else if feature.geometry.type is "MultiPolygon"
                        feature.geometry.coordinates.forEach (array) ->
                            array[0].forEach (latLng) ->
                                if Parser.isCoordinate(latLng[0]) and Parser.isCoordinate(latLng[1])
                                    latLng = L.GeoJSON.coordsToLatLng(latLng)
                                    coordinates.push(latLng)
                    else
                        console.warn "Geometry type not supported."

                if coordinates.length
                    @bounds = L.latLngBounds(coordinates)
                    @map.fitBounds(@bounds, {maxZoom: 15})

            # @method updateGeoJSONwithSHP
            # @description updates the geoJSON object(generated from shp file) used for the map after data table changes.
            # @param {integer} row
            # @param {integer} column
            # @param {number or string} oldData
            # @param {number or string} newData
            # @param {string} key
            # @return {boolean}
            updateGeoJSONwithSHP: (row, column, oldData, newData, key) ->
                keys = key.split(" ")

                if keys[0] is "coordinates"
                    if Helper.isNumeric(newData)
                        if @geoJSON.features[row].geometry.type is "Point"
                            if @geoJSON.features[row].geometry.coordinates[keys[1]] == oldData
                                @geoJSON.features[row].geometry.coordinates[keys[1]] = newData
                            else
                                console.warn "Point does not exist"
                                return false
                        else if @geoJSON.features[row].geometry.type is "Polygon"
                            arrayIndex = Math.floor(keys[1] / 2)
                            index = keys[1] % 2
                            if Array.isArray(@geoJSON.features[row].geometry.coordinates[0][arrayIndex])
                                @geoJSON.features[row].geometry.coordinates[0][arrayIndex][index] = newData
                            else
                                console.warn "Array does not exist and can't be updated"
                                # The table has to be reseted if the array can't be updated
                                return false
                    else
                        console.warn "Value is not a Number"
                        return false

                else if keys[0] is "bbox"
                    if Helper.isNumeric(newData)
                        @geoJSON.features[row].geometry.bbox[keys[1]] = newData
                    else
                        console.warn "Value is not a Number"
                        return false

                    # check if colHeader is part of properties
                else
                    for property, value of @geoJSON.features[row].properties
                        if key == property
                            @geoJSON.features[row].properties[key] = newData

                @setBoundsToGeoJSON()
                return true

            getGeoJSON: ->
                return @geoJSON

        new Map
]
