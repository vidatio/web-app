"use strict"

app = angular.module "app.services"

app.service 'UserService', [
    "$http"
    "AuthenticationFactory"
    "UserAuthFactory"
    "$rootScope"
    "$log"
    "$q"
    "$translate"
    "ngToast"
    ($http, AuthenticationFactory, UserAuthFactory, $rootScope, $log, $q, $translate, ngToast) ->
        class User
            constructor: ->
                @user =
                    name: ""
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
                    $log.info "UserService init error of authorization called (401)"
                    $log.debug
                        error: error

                    $rootScope.globals.authorized = false
                    AuthenticationFactory.clearCredentials()
                    deferred.reject error
                )

                deferred.promise

            logout: ->
                $log.info "UserService logout called"

                @user =
                    name: ""
                $rootScope.globals.authorized = undefined
                AuthenticationFactory.clearCredentials()

        new User
]
