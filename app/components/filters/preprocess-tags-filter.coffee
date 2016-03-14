"use strict"

app = angular.module "app.filters"

app.filter "preprocessTags", [
    "$log"
    ($log) ->
        # @method Anonymous Function
        # @param {Array} input
        # @return {Array}
        return (input) ->
            $log.info "PreprocessTagsFilter called"

            return input if not input

            output = []
            for element in input
                output.push element?.name

            output.join(", ")
]
