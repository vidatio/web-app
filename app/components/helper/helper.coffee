"use strict"

app = angular.module "app.services"

app.service 'HelperService', [
    "$log"
    ($log) ->
        class Helper
            constructor: ->
                $log.info "HelperService constructor called"
                @rowLimit = 30

            # remove cells without values
            # @method trimDataset
            # @public
            # @param {Array} dataset
            # @return {Array}
            trimDataset: (dataset) ->
                $log.info "HelperService trimDataset called"
                $log.debug
                    message: "HelperService trimDataset called"
                    dataset: dataset

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
                $log.info "HelperService createMatrix called"
                $log.debug
                    message: "HelperService createMatrix called"
                    dataset: dataset
                    initial: initial

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
                $log.info "HelperService isNumber called"
                $log.debug
                    message: "HelperService isNumber called"
                    value: value

                return typeof value is "number" and isFinite(value)

            # @method isNumeric
            # @description checks if a value is numeric.
            # @param {Mixed} n
            # @return {Boolean}
            isNumeric: (value) ->
                $log.info "HelperService isNumeric called"
                $log.debug
                    message: "HelperService isNumeric called"
                    value: value

                return (!isNaN(parseFloat(value)) && isFinite(value))

            # cut out specified amount of rows
            # @method cutDataset
            # @public
            # @param {Array} dataset
            # @return {Array}
            cutDataset: (dataset) ->
                $log.info "HelperService cutDataset called"
                $log.debug
                    message: "HelperService cutDataset called"
                    dataset: dataset

                tmp = []
                for element, index in dataset
                    if index is @rowLimit
                        break
                    tmp.push element

                return tmp

            dateToString: (date) ->
                $log.info "HelperService dateToString called"
                $log.debug
                    message: "HelperService dateToString called"
                    date: date

                yyyy = date.getFullYear().toString()
                mm = (date.getMonth() + 1).toString()
                dd = date.getDate().toString()
                hh = date.getHours().toString()
                min = date.getMinutes().toString()
                sec = date.getSeconds().toString()
                return dd + "-" + mm + "-" + yyyy + "_" + hh + "-" + min + "-" + sec

        new Helper
]
