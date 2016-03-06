"use strict"

app = angular.module "app.filters"

app.filter "categoryFilter", [
    "$log"
    ($log) ->
        return (input, category) ->
            $log.info "CategoryFilter called"
            $log.debug
                category: category

            return input if not category or not input

            output = []

            for element in input
                output.push(element) if element.metaData.category.toLowerCase() is category.toLowerCase()

            output
]
