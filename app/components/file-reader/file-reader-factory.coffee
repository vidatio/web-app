# File-Reader Factory
# ======================

"use strict"

app = angular.module "upload.services"

app.factory 'FileReader', [
    "$q"
    "$log"
    ($q, $log) ->

        onLoad = (reader, deferred, scope) ->
            ->
                scope.$apply ->
                    deferred.resolve reader.result
                    return
                return

        onError = (reader, deferred, scope) ->
            ->
                scope.$apply ->
                    deferred.reject reader.result
                    return
                return

        onProgress = (reader, scope) ->
            (event) ->
                scope.$broadcast 'fileProgress',
                    total: event.total
                    loaded: event.loaded
                return

        getReader = (deferred, scope) ->
            reader = new FileReader
            reader.onload = onLoad(reader, deferred, scope)
            reader.onerror = onError(reader, deferred, scope)
            reader.onprogress = onProgress(reader, scope)
            reader

        readAsDataUrl = (file, scope) ->
            deferred = $q.defer()
            reader = getReader(deferred, scope)
            reader.readAsText file
            deferred.promise

        { readAsDataUrl: readAsDataUrl }

]
