"use strict"

app = angular.module("app.controllers")

app.controller "LoginCtrl", [
    "$scope"
    "AuthenticationFactory"
    "UserService"
    "$rootScope"
    "$state"
    "$log"
    ($scope, AuthenticationFactory, UserService, $rootScope, $state, $log) ->
        $scope.logon = ->
            $log.info "UserCtrl logon called"

            if $rootScope.globals.currentUser
                $log.info "UserCtrl current user does exist"

                AuthenticationFactory.setExistingCredentials $rootScope.globals.currentUser
                UserService.init $rootScope.globals.currentUser.name
                return

            AuthenticationFactory.clearCredentials()

            if $scope.loginForm.$invalid
                if $scope.loginForm.name.$error.required
                    console.log "name required"
                    return
                if $scope.loginForm.password.$error.required
                    console.log "password required"
                    return

            # proceed login
            AuthenticationFactory.setCredentials(
                $scope.user.name, $scope.user.password
            )

            UserService.init($scope.user).then(
                (value) ->
                    $log.info "UserCtrl successfully logged in"
                    $log.debug
                        value: value

                    # TODO refactor
                    unless $rootScope.history.length
                        $log.info "UserCtrl redirect to app.index"

                        # TODO current locale instead of preferredLanguage
                        $state.go "app.index"
                        return

                    # TODO refactor
                    for element in $rootScope.history
                        element = $rootScope.history[$rootScope.history.length - 1]
                        if element.name isnt "app.login" and element.name isnt "app.registration" and element.name isnt ""
                            $log.info "UserCtrl redirect to " + element.name

                            $state.go element.name, element.params.locale
                            return

                    $state.go "app.index"

                (error) ->
                    $log.info "UserCtrl error on login"
            )

        #Needed for flat UI prepend tags
        $('.input-group').on('focus', '.form-control', ->
            $(this).closest('.input-group, .form-group').addClass 'focus'
        ).on 'blur', '.form-control', ->
            $(this).closest('.input-group, .form-group').removeClass 'focus'
]
