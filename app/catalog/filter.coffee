"use strict"

app = angular.module "app.filters"

app.filter "dateFilter", ->
    return (input, from, to) ->
        return input if not from and not to

        fromDate = new Date(from)
        output = []

        for element in input
            output.push(element) if element.createdAt >= fromDate

        output
