"use strict"

app = angular.module "app.factories"

app.factory "AuthenticationFactory", [
    "Base64"
    "$http"
    "$cookieStore"
    "$rootScope"
    (Base64, $http, $cookieStore, $rootScope) ->

        setCredentials: (name, password) ->#
            $log.info "AuthenticationFactory setCredentials called"
            $log.debug
                name: name
                password: password

            authdata = Base64.encode name + ":" + password

            $rootScope.globals =
                currentUser:
                    name: name
                    authdata: authdata

            $http.defaults.headers.common["Authorization"] = "Basic " + authdata
            $cookieStore.put "globals", $rootScope.globals

        setExistingCredentials: (user) ->
            $log.info "AuthenticationFactory setExistingCredentials called"
            $log.debug
                user: user

            $rootScope.globals.currentUser = user
            $http.defaults.headers.common["Authorization"] = "Basic " + user.authdata
            $cookieStore.put "globals", $rootScope.globals

        clearCredentials: ->
            $log.info "AuthenticationFactory clearCredentials called"

            delete $rootScope.globals.currentUser
            $cookieStore.remove "globals"
            $http.defaults.headers.common.Authorization = "Basic "

]
