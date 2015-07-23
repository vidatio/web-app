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

                # check file format
                type = file.name.split "."
                type = type[type.length - 1]

                console.log "type : ", type

                switch type
                    when "csv"
                        console.log "format: csv"
                        @reader.readAsText file
                        @deferred.promise.then (result) ->
                            return result
                            
                    when "zip"
                        console.log "format : zip"
                        @reader.readAsArrayBuffer file
                        @deferred.promise.then (result) ->
                            return Parser.zip result

                    else
                        console.log "File format is not supported."
                        return

        new Reader
]