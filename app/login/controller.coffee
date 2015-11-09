"use strict"

app = angular.module("app.controllers")

app.controller "LoginCtrl", [
    "$scope"
    "AuthenticationService"
    "UserService"
    "$rootScope"
    "$state"
    "$log"
    ($scope, AuthenticationService, UserService, $rootScope, $state, $log) ->
        $scope.logon = ->
            $log.info "UserCtrl logon called"

            if $rootScope.globals.currentUser
                $log.info "UserCtrl current user does exist"

                AuthenticationService.SetExistingCredentials $rootScope.globals.currentUser
                UserService.init $rootScope.globals.currentUser.name
                return

            AuthenticationService.ClearCredentials()

            if $scope.loginForm.$invalid
                if $scope.loginForm.name.$error.required
                    console.log "name required"
                    return
                if $scope.loginForm.password.$error.required
                    console.log "password required"
                    return

            # proceed login
            AuthenticationService.SetCredentials(
                $scope.user.name, $scope.user.password
            )

            UserService.init($scope.user).then(
                (value) ->
                    $log.info "UserCtrl successfully logged in"
                    $log.debug
                        value: value

                    unless $rootScope.history.length
                        $log.info "UserCtrl redirect to app.index"

                        # TODO current locale instead of preferredLanguage
                        $state.go "app.index"
                        return

                    $rootScope.history.forEach (element, index, history) ->
                        console.log "UserCtrl forEach history"

                        element = history[history.length - 1]

                        if element != "app.login" or element != "app.registration"
                            $log.info "UserCtrl redirect to " + element.name

                            $state.go element.name, element.params.locale

                (error) ->
                    $log.info "UserCtrl error on login"
            )

        #Needed for flat UI prepend tags
        $('.input-group').on('focus', '.form-control', ->
            $(this).closest('.input-group, .form-group').addClass 'focus'
        ).on 'blur', '.form-control', ->
            $(this).closest('.input-group, .form-group').removeClass 'focus'
]
