"use strict"

app = angular.module "app.filters"

app.filter "dateFilter", [ ->
        # @method Anonymous Function
        # @param {Array} input
        # @param {Date or String} from
        # @param {Date or String} to
        # @return {Array}
        return (input, from, to) ->
            return input if not from and not to or not input

            fromDate = new Date(from)
            toDate = new Date(to)
            output = []

            toDate.setHours(23)
            toDate.setMinutes(59)
            toDate.setSeconds(59)

            for element in input
                output.push(element) if isNaN(toDate) and element.createdAt >= fromDate
                output.push(element) if isNaN(fromDate) and element.createdAt <= toDate
                output.push(element) if element.createdAt >= fromDate and element.createdAt <= toDate

            output
]
