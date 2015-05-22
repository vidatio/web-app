# Authentication Service
# ======================

"use strict"

app = angular.module "app.services"

app.factory "AuthenticationService", [
    "Base64"
    "$http"
    "$cookieStore"
    "$rootScope"
    ( Base64, $http, $cookieStore, $rootScope ) ->
        service = {}

        service.SetCredentials = ( name, password ) ->
            authdata = Base64.encode name + ":" + password

            $rootScope.globals =
                currentUser:
                    name: name
                    authdata: authdata

            $http.defaults.headers.common["Authorization"] = "Basic " + authdata
            $cookieStore.put "globals", $rootScope.globals

        service.SetExistingCredentials = ( user ) ->
            $rootScope.globals.currentUser = user

            $http.defaults.headers.common["Authorization"] = "Basic " + user.authdata
            $cookieStore.put "globals", $rootScope.globals


        service.ClearCredentials = ->
            delete $rootScope.globals
            $cookieStore.remove "globals"
            $http.defaults.headers.common.Authorization = "Basic "

        return service
]
