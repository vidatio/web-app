# File-Reader Service
# ======================

"use strict"

app = angular.module "app.services"

app.service 'FileReaderService', [
    "$q"
    ($q) ->
        Reader = ->
            @reader = new FileReader()
            @deferred = undefined
            @progress = 0

        Reader::readAsDataUrl = (file) ->
            @deferred = $q.defer()
            @progress = 0

            @reader.onload = (->
                @deferred.resolve @reader.result
            ).bind(this)

            @reader.onerror = (->
                @deferred.reject @reader.result
            ).bind(this)

            @reader.onprogress = ((event) ->
                @progress = event.loaded / event.total
            ).bind(this)

            @reader.readAsText file
            @deferred.promise

        new Reader
]
