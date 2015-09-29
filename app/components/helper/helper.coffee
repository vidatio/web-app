"use strict"

app = angular.module "app.services"

app.service 'HelperService', [ ->
    class Helper
        constructor: ->
            @rowLimit = 100

        # remove cells without values
        # @method trimDataset
        # @public
        # @param {Array} dataset
        # @return {Array}
        trimDataset: (dataset) ->
            tmp = []

            topRow = undefined
            leftCell = Infinity
            rightCell = -Infinity
            bottomRow = -Infinity

            dataset.forEach (row, indexRow) ->
                row.forEach (cell, indexCell) ->
                    if cell
                        if typeof topRow == 'undefined'
                            topRow = indexRow
                        if leftCell > indexCell
                            leftCell = indexCell
                        if bottomRow < indexRow
                            bottomRow = indexRow
                        if rightCell < indexCell
                            rightCell = indexCell

            dataset.forEach (row, indexRow) ->
                if indexRow < topRow or indexRow > bottomRow
                    return
                tmp.push row.slice(leftCell, rightCell + 1)

            return tmp

        # @method trimDataset
        # @public
        # @param {Array} dataset is used to create a matrix which has the the same dimensions as the dataset
        # @param {Number} initial value of each cell
        # @return {Array}
        createMatrix: (dataset, initial) ->
            matrix = []
            dataset.forEach (row, indexRow) ->
                matrix.push([])
                row.forEach (column, indexColumn) ->
                    matrix[indexRow][indexColumn] = initial

            return matrix

        # @method isNumber
        # @public
        # @param {All Types} value
        # @return {Boolean}
        isNumber: (value) ->
            return typeof value is "number" and isFinite(value)


        # copy specified amount of rows
        # @method cutDataset
        # @public
        # @param {Array} dataset
        # @return {Array}
        cutDataset: (dataset) ->
            tmp = []
            for element, index in dataset
                if index == @rowLimit
                    break
                tmp.push element

            return tmp

    new Helper
]
