"use strict"

app = angular.module "animals.services"


app.service "UserService", [
    "UserFactory"
    "AuthenticationService"
    "ProgressService"
    "$rootScope"
    "$q"
    ( UserFactory, AuthenticationService, ProgressService, $rootScope, $q ) ->
        new class User
            constructor: ->
                @user = name: ""

            init: =>
                console.log "user", @user
                ProgressService.startLoading()

                deferred = $q.defer()

                UserFactory.get().$promise.then(
                    (result) =>
                        @user = result
                        console.log "result", result
                        console.log "user", @user
                        $rootScope.globals.authorized = true
                        ProgressService.finishedLoading()
                        deferred.resolve @user

                    , (error) ->
                        $rootScope.globals.authorized = false
                        AuthenticationService.ClearCredentials()
                        ProgressService.finishedLoading()
                        deferred.reject error
                )

                deferred.promise



            logout: ->
                @user = name: ""
                $rootScope.globals.authorized = undefined
                AuthenticationService.ClearCredentials()

]
