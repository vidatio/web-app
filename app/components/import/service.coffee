## ImportService
# For reading files
# For converting data sets
# For setting the table
## ======================

"use strict"

app = angular.module "app.services"

app.service 'ImportService', [
    "$q"
    "ConverterService"
    "TableService"
    ($q, Converter, Table) ->
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

                @reader.onprogress = (event) =>
                    @progress = (event.loaded / event.total).toFixed(2) * 100

                switch fileType
                    when "csv"
                        @reader.readAsText file
                    when "zip"
                        @reader.readAsArrayBuffer file

                return @deferred.promise
        new Reader
]
