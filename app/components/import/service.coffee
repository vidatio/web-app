## ImportService
# For reading files
# For converting data sets
# For setting the table
## ======================

"use strict"

app = angular.module "app.services"

app.service 'ImportService', [
    "$q"
    ($q) ->
        class Reader
            constructor: ->
                @reader = new FileReader()
                @deferred = undefined
                @progress = 0

            readFile: (file, fileType) ->
                @deferred = $q.defer()
                @progress = 0

                @reader.onload = =>
                    @deferred.resolve @reader.result

                @reader.onerror = =>
                    @deferred.reject @reader.result

                switch fileType
                    when "csv"
                        @reader.readAsText file
                    when "zip"
                        @reader.readAsArrayBuffer file

                return @deferred.promise
        new Reader
]
