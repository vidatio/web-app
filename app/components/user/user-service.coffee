# User Service
# ============

"use strict"

app = angular.module "app.services"


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
                ProgressService.startLoading()

                deferred = $q.defer()

                UserFactory.get().$promise.then(
                    (result) =>
                        @user = result
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
