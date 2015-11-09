"use strict"

app = angular.module "app.services"

app.service 'UserService', [
    "$http"
    "AuthenticationService"
    "UserAuthFactory"
    "$rootScope"
    "$log"
    "$q"
    ($http, AuthenticationService, UserAuthFactory, $rootScope, $log, $q) ->
        class User
            constructor: ->
                @user = name: ""
            checkUniqueness: (key, value) ->
                $log.info "UserService checkUniqueness called"
                $log.debug
                    key: key
                    value: value

                url = $rootScope.apiBase + "/v0/users/check?" + key + '=' + escape(value)
                $http.get(url).then (results) ->
                    $log.info "UserService checkUniqueness success (user does not exist)"
                    $log.debug
                        results: results

                    console.log results.data.status

                    if results.data.available
                        $q.resolve(results)
                    else
                        $q.reject(results)
                , (error) ->
                    $log.error "UserService checkUniqueness get error (user exists already)"
                    $log.debug
                        error: error

                    $q.reject(error)

            init: =>
                $log.info "UserService init called"

                deferred = $q.defer()

                UserAuthFactory.get().$promise.then(
                    (result) =>
                        $log.info "UserService init success called"
                        $log.debug
                            result: result

                        @user = result
                        $rootScope.globals.authorized = true
                        deferred.resolve @user

                , (error) ->
                    $log.info "UserService init error called"
                    $log.debug
                        error: error

                    $rootScope.globals.authorized = false
                    AuthenticationService.ClearCredentials()
                    deferred.reject error
                )

                deferred.promise

            logout: ->
                $log.info "UserService logout called"

                @user = name: ""
                $rootScope.globals.authorized = undefined
                AuthenticationService.ClearCredentials()

        new User
]

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
