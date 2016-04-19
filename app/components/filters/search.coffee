"use strict"

app = angular.module "app.filters"

app.filter "searchFilter", [ ->
        return (input, search) ->
            return input if not search or not input

            output = []

            for element in input
                name = (element.metaData.name).toLowerCase()
                if name.indexOf(search.toLowerCase()) > -1
                    output.push(element)

            output
]
