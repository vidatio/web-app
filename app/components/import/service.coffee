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

            readFile: (file) ->
                @deferred = $q.defer()
                @progress = 0

                @reader.onload = =>
                    @deferred.resolve @reader.result

                @reader.onerror = =>
                    @deferred.reject @reader.result

                @reader.onprogress = (event) =>
                    @progress = event.loaded / event.total

                # Can't use file.type because of chromes File API
                fileType = file.name.split "."
                fileType = fileType[fileType.length - 1]
                switch fileType
                    when "csv"
                        @reader.readAsText file
                        @deferred.promise.then (fileContent) =>
                            dataset = Converter.convertCSV2Arrays(fileContent)
                            @deferred.resolve(dataset)

                    when "zip"
                        @reader.readAsArrayBuffer file
                        @deferred.promise.then (result) =>
                            Converter.convertSHP2Arrays(result).then (dataset) =>
                                @deferred.resolve(dataset)

                    else
                        message = "File format '" + fileType + "' is not supported."
                        @deferred.reject(message)

                return @deferred.promise
        new Reader
]
