"use strict"

app = angular.module("app.controllers")

app.controller "LoginCtrl", [
    "$scope"
    "UserService"
    "$rootScope"
    "$state"
    "$log"
    "$translate"
    "ngToast"
    "$stateParams"
    ($scope, UserService, $rootScope, $state, $log, $translate, ngToast) ->
        $scope.logon = ->
            $log.info "UserCtrl logon called"

            UserService.logon($scope.user).then(
                (value) ->
                    $log.info "UserCtrl successfully logged in"
                    $log.debug
                        value: value

                    # Default routing for user at logout success
                    unless $rootScope.history.length
                        $log.info "UserCtrl redirect to app.index"
                        $state.go "app.index"
                        return

                    # After login success we want to route the user to the last page except login and registration
                    for element in $rootScope.history
                        element = $rootScope.history[$rootScope.history.length - 1]

                        if element.name isnt "app.login" and element.name isnt "app.registration" and element.name isnt ""
                            $log.info "UserCtrl redirect to " + element.name

                            # redirect to detailview needs vidatio-id, so an additional if is necessary to transfer the id
                            if element.name is "app.dataset"
                                $state.go element.name, 'id': element.params.id, element.params.locale
                                return

                            $state.go element.name, element.params.locale
                            return

                    $state.go "app.index"

                (error) ->
                    $log.info "UserCtrl error on login"

                    $translate('TOAST_MESSAGES.NOT_AUTHORIZED').then (translation) ->
                        ngToast.create
                            content: translation
                            className: "danger"
            )

        # To give the prepends tags of flat ui the correct focus style
        $('.input-group').on('focus', '.form-control', ->
            $(this).closest('.input-group, .form-group').addClass 'focus'
        ).on 'blur', '.form-control', ->
            $(this).closest('.input-group, .form-group').removeClass 'focus'
]
