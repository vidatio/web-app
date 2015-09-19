"use strict"

app = angular.module "app.services"

# TODO: after extracting coordinates they have to be converted to decimal format

app.service 'ConverterService', [
    "ParserService"
    (Parser) ->
        class Converter
            convertSHP2GeoJSON: (buffer) ->
                shp(buffer).then (geoJSON) ->
                    return geoJSON

            convertCSV2Arrays: (csv) ->
                return Papa.parse(csv).data

            convertSHP2Arrays: (shp) ->
                return @convertSHP2GeoJSON(shp).then (geoJSON) ->
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
                                        feature.geometry.coordinates.forEach (polygon) ->
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

            convertArrays2GeoJSON: (dataset) ->
                dataset = _trimDataset(dataset)

                geoJSON =
                    "type": "FeatureCollection"
                    "features": []

                indicesCoordinates = Parser.findCoordinatesColumns(dataset)

                dataset.forEach (row) ->
                    coordinates = []

                    if indicesCoordinates.hasOwnProperty("xy")
                        coordinates = Parser.extractCoordinatesOfOneCell row[indicesCoordinates["xy"]]
                    else if indicesCoordinates.hasOwnProperty("x") && indicesCoordinates.hasOwnProperty("y")
                        coordinates.push(parseFloat(row[indicesCoordinates["y"]]))
                        coordinates.push(parseFloat(row[indicesCoordinates["x"]]))
                    else
                        # TODO print failure to the user
                        return

                    if coordinates.length == 0
                        return

                    feature = JSON.parse(JSON.stringify(
                        "type": "Feature"
                        "geometry":
                            "type": undefined
                            "coordinates": []
                    ))

                    if coordinates.length == 2
                        longitude = parseFloat(coordinates[1])
                        latitude = parseFloat(coordinates[0])
                        feature.geometry.coordinates = [longitude, latitude]
                        feature.geometry.type = "Point"
                    else if coordinates.length == 4
                        latitude0 = parseFloat(coordinates[0])
                        longitude0 = parseFloat(coordinates[1])
                        latitude1 = parseFloat(coordinates[2])
                        longitude1 = parseFloat(coordinates[3])
                        feature.geometry.coordinates = [[longitude0, latitude0], [longitude1, latitude1]]
                        feature.geometry.type = "LineString"
                    else
                        #coordinates.forEach (coordinate, index) ->
                        # TODO: 2 Arrays: Line, mehr: Polygon, lat - long für GeoJSON vertauschen
                        return

                    geoJSON.features.push(feature)

                console.log geoJSON
                return geoJSON

            # TODO remove this method here or the one in the ParserService
            _trimDataset = (dataset) ->
                tmp = []
                minColumns = 0
                minRows = 0

                # before trim the dataset we have to check the dimensions
                dataset.forEach (row, indexRow) ->
                    row.forEach (cell, indexCell) ->
                        if(cell != null && String(cell) != "")
                            if(minRows < indexRow)
                                minRows = indexRow

                            if(minColumns < indexCell)
                                minColumns = indexCell

                # trim dataset with analysed dimensions
                dataset.forEach (row, indexRow) ->
                    if(indexRow > minRows)
                        return
                    tmp[indexRow] = row.slice(0, minColumns + 1)

                return tmp

            _isNumber = (value) ->
                return typeof value == "number" && isFinite(value)

            _areCoordinatesNumbers = (coordinates) ->
                result = true
                coordinates.forEach (coordinate) ->
                    if !_isNumber(coordinate)
                        result = false
                        return
                return result
        new Converter
]
