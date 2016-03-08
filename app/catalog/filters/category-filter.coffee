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
                if  element.metaData and
                    element.metaData.category and
                    element.metaData.category.name.toLowerCase() is category.toLowerCase()
                        output.push(element)

            output
]
