"use strict"

app = angular.module "app.filters"

app.filter "categoryFilter", [ ->
        # @method Anonymous Function
        # @param {Array} input
        # @param {String} category
        # @return {Array}
        return (input, category) ->
            return input if not category or not input

            output = []

            for element in input
                if element.metaData?.category?.name? and element.metaData.category.name.toLowerCase() is category.toLowerCase()
                        output.push(element)

            output
]
