# Penguin Service
# ===============

"use strict"

app = angular.module "animals.services"


app.service "PenguinService", [
    "PenguinFactory"
    "$q"
    "ProgressService"
    "$timeout"
    ( PenguinFactory, $q, ProgressService, $timeout ) ->
        new class Penguins
            constructor: ->
                @penguins = []
                @penguin  = {}

            query: ->
                deferred = $q.defer()
                ProgressService.startLoading()
                PenguinFactory.query().$promise.then(
                    ( result ) =>
                        @penguins = result
                        deferred.resolve @penguins
                        ProgressService.finishedLoading()
                    ( error ) ->
                        deferred.reject error
                        ProgressService.finishedLoading()
                )

                deferred.promise

            get: ( id ) ->
                deferred = $q.defer()
                ProgressService.startLoading()
                PenguinFactory.get( {id: id} ).$promise.then(
                    ( result ) =>
                        @penguin = result
                        for penguin, i in @penguins when penguin._id is id
                            for key, value of penguin
                                @penguins[i][key] = value

                        deferred.resolve @penguin
                        ProgressService.finishedLoading()
                    ( error ) ->
                        deferred.reject error
                        ProgressService.finishedLoading()
                )

                deferred.promise

            create: ( penguin ) ->
                deferred = $q.defer()

                ProgressService.startLoading()
                PenguinFactory.save( penguin ).$promise.then(
                    ( result ) =>
                        @penguins.push result
                        ProgressService.finishedLoading()
                        deferred.resolve result
                    ( error ) ->
                        ProgressService.finishedLoading()
                        deferred.reject error
                )

                deferred.promise

            delete: ( penguin ) ->
                deferred = $q.defer()

                ProgressService.startLoading()
                PenguinFactory.remove( { id: penguin } ).$promise.then(
                    ( result ) =>
                        for _penguin, index in @penguins
                            if _penguin._id is penguin
                                @penguins.splice index, 1
                                break

                        ProgressService.finishedLoading()
                        deferred.resolve result
                    ( error ) ->
                        deferred.reject error
                        ProgressService.finishedLoading()
                )
]
