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
    "$state"
    ($http, UserAuthFactory, UserUniquenessFactory, $rootScope, $log, $q, Base64, $cookieStore, $state) ->
        class User
            # @method constructor
            # @public
            constructor: ->
                @user = {}

            # @method checkUniqueness
            # @public
            # @param {String} key
            # @param {String} value
            checkUniqueness: (key, value) ->
                params = {}
                params[key] = escape(value)

                UserUniquenessFactory.check(params).$promise
                .then (results) ->
                    if results["available"]
                        $q.resolve(results)
                    else
                        $q.reject(results)
                .catch (error) ->
                    $q.reject(error)

            # @method logon
            # @public
            # @param {String} user
            logon: (user) =>
                deferred = $q.defer()

                authData = Base64.encode(user.name + ":" + user.password)
                $http.defaults.headers.common["Authorization"] = "Basic " + authData

                UserAuthFactory.get().$promise
                .then (result) =>
                    @user = result.user
                    @setCredentials(@user.name, @user._id, authData)

                    deferred.resolve @user

                    @redirect()

                .catch (error) =>
                    @logout()
                    deferred.reject error

                deferred.promise

            # @method logout
            # @public
            logout: =>
                @user = name: ""
                $rootScope.globals.authorized = undefined
                delete $rootScope.globals.currentUser
                $cookieStore.remove "globals"
                $http.defaults.headers.common.Authorization = "Basic "
                $state.go "app.index" if $state.$current.name is "app.profile"

            # @method setCredentials
            # @public
            # @param {String} name
            # @param {String} userID
            setCredentials: (name, userID, authData) ->
                $rootScope.globals =
                    currentUser:
                        name: name
                        authData: authData
                        id: userID
                $cookieStore.put "globals", $rootScope.globals
                $rootScope.globals.authorized = true

            # @method redirect
            # @public
            # @description redirect user to last visited pages before login-/ registration-page was entered;
            # @description redirect to app.index if visited pages were only app.login or app.registration
            redirect: ->
                # After login success we want to route the user to the last page except login and registration
                for element, index in $rootScope.history
                    element = $rootScope.history[$rootScope.history.length - (index + 1)]

                    unless element.name in ["app.login", "app.registration", ""]
                        # redirect to detailview needs vidatio-id, so an additional if is necessary to transfer the id
                        unless element.name in ["app.dataset", "app.editor.id", "app.share.id"]
                            return $state.go element.name, element.params.locale

                        return $state.go element.name, 'id': element.params.id, element.params.locale

                return $state.go "app.index"

        new User
]
