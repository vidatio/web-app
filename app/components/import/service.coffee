# FileReader Service
# ======================

"use strict"

app = angular.module "app.services"

app.service 'ImportService', [
    "$q"
    "ParserService"
    ($q, Parser) ->
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
                        console.log "format: csv"
                        @reader.readAsText file
                        @deferred.promise.then (result) =>
                            @deferred.resolve(result)

                    when "zip"
                        console.log "format : zip"
                        @reader.readAsArrayBuffer file
                        @deferred.promise.then (result) =>
                            result = Parser.zip result
                            @deferred.resolve(result)

                    else
                        message = "File format '" + fileType + "' is not supported."
                        @deferred.reject(message)

                return @deferred.promise
        new Reader
]
