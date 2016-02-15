"use strict"

app = angular.module "app.filters"

app.filter "dateFilter", [
    "$log"
    ($log) ->
        return (input, from, to) ->
            $log.info "DateFilter called"
            $log.debug
                from: from
                to: to

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
