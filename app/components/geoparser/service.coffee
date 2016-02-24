"use strict"

class window.vidatio.GeoParser

    # @method extractCoordinatesOfOneCell
    # @public
    # @param {String} cell
    # @return {Array}
    extractCoordinatesOfOneCell: (cell) ->
        vidatio.log.info "ParserService extractCoordinatesOfOneCell called"
        vidatio.log.debug
            cell: cell

        # TODO: match other than decimal coordinate formats (e.g. N 123° 13.15 )

        # extract the following numbers:
        #    123.45, 123, -123, -123.45
        regex = /(?:-)?(?:\d+)(?:\.\d+)?/g

        coordinates = []
        while((coordinate = regex.exec(cell)) != null)
            if(vidatio.helper.isCoordinate(coordinate[0]))
                coordinates.push coordinate[0]

        return coordinates

    # @method checkHeader
    # @public
    # @param {Array} header
    # @return {Object}
    #   success: find white listed column name
    #   x: index of the x column
    #   y: index of the y column
    checkHeader: (header) ->
        vidatio.log.info "GeoParser checkHeader called"
        vidatio.log.debug
            header: header

        indicesCoordinates = {}

        for cell, index in header
            if indicesCoordinates.hasOwnProperty("x") and indicesCoordinates.hasOwnProperty["y"]
                break

            unless cell
                break

            headerColumnIndex = _checkWhiteList.call(this, cell)
            if headerColumnIndex is "x" or headerColumnIndex is "y"
                indicesCoordinates[headerColumnIndex] = index
            else if headerColumnIndex is "xy"
                indicesCoordinates["x"] = index
                indicesCoordinates["y"] = index

        return indicesCoordinates

    # every coordinate format has a 2d like mapping
    # so we search for x values and y values
    _whiteList =
        "x": [
            "x"
            "lng"
            "longitude"
        ]
        "y": [
            "y"
            "latitude"
        ]
        "xy": [
            "Geometrie"
            "Geometry"
        ]

    # @method _checkWhiteList
    # @private
    # @param {String} word
    # @return {String}
    _checkWhiteList = (word) ->
        vidatio.log.info "ParserService _checkWhiteList called"
        vidatio.log.debug
            message: "ParserService _checkWhiteList called"
            word: word

        result = undefined
        word = String(word).trim().toLowerCase()

        _whiteList["x"].forEach (item) ->
            if item.toLowerCase().indexOf(word) >= 0
                result = "x"
                return

        if !result
            _whiteList["y"].forEach (item) ->
                if item.toLowerCase().indexOf(word) >= 0
                    result = "y"
                    return

        if !result
            _whiteList["xy"].forEach (item) ->
                if item.toLowerCase().indexOf(word) >= 0
                    result = "xy"
                    return

        return result
