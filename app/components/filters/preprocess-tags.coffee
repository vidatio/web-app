"use strict"

app = angular.module "app.filters"

app.filter "preprocessTags", [ ->
        # @method Anonymous Function
        # @param {Array} input
        # @return {Array}
        return (input) ->
            return input if not input

            output = []
            for element in input
                output.push element?.name

            output.join(", ")
]
