"use strict"

app = angular.module "app.services"

app.factory 'ConverterService', [ ->
    class Converter
        convertSHP2GeoJSON: (buffer) ->
            shp(buffer).then (geoJSON) ->
                return geoJSON

        convertCSV2Arrays: (csv) ->
            return Papa.parse(csv).data

        convertGeoJSON2Arrays: (geoJSON) ->
                dataset = []

                geoJSON.features.forEach (feature) ->
                    if feature.geometry.type == "MultiPolygon"
                        feature.geometry.coordinates.forEach (polygon, index) ->
                            newRow = []

                            for property, value of feature.properties
                                newRow.push value

                            for property, value of feature.geometry
                                if property == "bbox"
                                    value.forEach (coordinate) ->
                                        newRow.push coordinate
                                else if property == "coordinates"
                                    newRow.push "Polygon " + (index + 1)
                                    polygon.forEach (pair) ->
                                        pair.forEach (coordinates) ->
                                            coordinates.forEach (coordinate) ->
                                                newRow.push coordinate
                                else
                                    newRow.push value

                            dataset.push newRow

                    else
                        newRow = []

                        for property, value of feature.properties
                            newRow.push value

                        for property, value of feature.geometry
                            if property == "bbox"
                                value.forEach (coordinate) ->
                                    newRow.push coordinate

                            else if property == "coordinates"
                                if feature.geometry.type == "Point"
                                    feature.geometry.coordinates.forEach (coordinate) ->
                                        newRow.push coordinate

                                else
                                    feature.geometry.coordinates.forEach (pair) ->
                                        pair.forEach (coordinates) ->
                                            coordinates.forEach (coordinate) ->
                                                    newRow.push coordinate

                            else
                                newRow.push value

                        dataset.push newRow

                return dataset

        addSpace: (value, array) =>
            if Array.isArray value
                value.forEach (element) =>
                    array.push ""
                    array = @addSpace(element, array)

            return array

        addLongLat: (value, array) =>
            if Array.isArray value
                value.forEach (element) =>
                    array.push "Latitude"
                    array.push "Longitude"
                    array = @aaddLongLat(element, array)

            return array

        addHeaderCols: (value, array, text, counter) =>
            if Array.isArray value
                value.forEach (element) =>
                    array.push text + " " + counter.toString()
                    counter++
                    array = @addHeaderCols(element, array, text, counter)

            return array

        convertGeoJSON2ColHeaders: (geoJSON) ->
            colHeaders = []

            for property, value of geoJSON.features[0].properties
                colHeaders.push property

            for property, value of geoJSON.features[0].geometry

                if property == "bbox" || property == "coordinates"
                    colHeaders = @addHeaderCols(value, colHeaders, property, 0)

                else
                    colHeaders.push property

            return colHeaders

        convertArrays2GeoJSON: (arrays) ->
            geoJSON =
                "type": "FeatureCollection"
                "features": []

            arrays.forEach (element) =>
                lat = parseFloat(element[0])
                lng = parseFloat(element[1])
                if @isCoordinate(lat, lng)
                    feature = JSON.parse(JSON.stringify(
                        "type": "Feature"
                        "geometry":
                            "type": undefined
                            "coordinates": []
                    ))
                    feature.geometry.coordinates = [parseFloat(lng), parseFloat(lat)]
                    feature.geometry.type = "Point"
                    geoJSON.features.push(feature)
            return geoJSON

        isCoordinate: (lat, lng) ->
            lat == Number(lat) and lat >= -90 and lat <= 90 &&
                lng == Number(lng) and lng >= -180 and lng <= 180

    new Converter
]
