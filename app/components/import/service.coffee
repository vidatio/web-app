# FileReader Service
# ======================

"use strict"

app = angular.module "app.services"

app.service 'ImportService', [
    "$q"
    "ParserService"
    "TableService"
    ($q, Parser, Table) ->
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

                fileType = file.name.split "."
                fileType = fileType[fileType.length - 1]

                switch fileType
                    when "csv"
                        @reader.readAsText file
                        @deferred.promise.then (result) =>
                            Table.setDataset result
                            @deferred.resolve(result)

                    when "zip"
                        @reader.readAsArrayBuffer file
                        @deferred.promise.then (result) =>
                            Parser.zip result
                                .then (geojson) =>
                                    Table.setDatasetFromGeojson geojson
                                    @deferred.resolve(geojson)

                    else
                        message = "File format '" + fileType + "' is not supported."
                        @deferred.reject(message)

                return @deferred.promise
        new Reader
]
