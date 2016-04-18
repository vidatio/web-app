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

            output = []

            for element in input
                createdAt = moment(element.createdAt)
                output.push(element) if not to and createdAt.isSameOrAfter(from, "day")
                output.push(element) if not from and createdAt.isSameOrBefore(to, "day")
                output.push(element) if from and to and createdAt.isSameOrAfter(from, "day") and createdAt.isSameOrBefore(to, "day")

            output
]
