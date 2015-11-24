"use strict"

app = angular.module "app.services"

app.service 'UserService', [
    "$http"
    "UserAuthFactory"
    "UserUniquenessFactory"
    "$rootScope"
    "$log"
    "$q"
    "Base64"
    "$cookieStore"
    ($http, UserAuthFactory, UserUniquenessFactory, $rootScope, $log, $q, Base64, $cookieStore) ->
        class User
            # @method constructor
            # @public
            constructor: ->
                @user =
                    name: ""

            # @method checkUniqueness
            # @public
            # @param {String} key
            # @param {String} value
            checkUniqueness: (key, value) ->
                $log.info "UserService checkUniqueness called"
                $log.debug
                    key: key
                    value: value

                params = {}
                params[key] = escape(value)

                console.log UserUniquenessFactory

                UserUniquenessFactory.check(params).$promise.then (results) ->
                    $log.info "UserService checkUniqueness success (user does not exist)"
                    $log.debug
                        results: results

                    if results["available"]
                        $q.resolve(results)
                    else
                        $q.reject(results)
                , (error) ->
                    $log.error "UserService checkUniqueness get error (user exists already)"
                    $log.debug
                        error: error

                    $q.reject(error)

            # @method setCredentials
            # @public
            # @param {String} name
            # @param {String} password
            logon: (user) =>
                $log.info "UserService logon called"
                $log.debug
                    name: user.name
                    password: user.password

                @setCredentials(user.name, user.password)
                deferred = $q.defer()

                UserAuthFactory.get().$promise.then (result) =>
                    $log.info "UserService init success called"
                    $log.debug
                        result: result

                    @user = result
                    $rootScope.globals.authorized = true
                    deferred.resolve @user
                , (error) =>
                    $log.info "UserService init error of authorization called (401)"
                    $log.debug
                        error: error

                    $rootScope.globals.authorized = false
                    @logout()
                    deferred.reject error

                deferred.promise

            # @method logout
            # @public
            logout: =>
                $log.info "UserService logout called"

                @user =
                    name: ""
                $rootScope.globals.authorized = undefined
                delete $rootScope.globals.currentUser
                $cookieStore.remove "globals"
                $http.defaults.headers.common.Authorization = "Basic "

            # @method setCredentials
            # @public
            # @param {String} name
            # @param {String} password
            setCredentials: (name, password) ->
                $log.info "UserService setCredentials called"
                $log.debug
                    name: name
                    password: password

                authData = Base64.encode(name + ":" + password)

                $rootScope.globals =
                    currentUser:
                        name: name
                        authData: authData

                $http.defaults.headers.common["Authorization"] = "Basic " + authData
                $cookieStore.put "globals", $rootScope.globals

        new User
]
