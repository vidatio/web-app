# Vidatio App
# ===========
"use strict"

app = angular.module "app", [
    "ui.router"
    "leaflet-directive"
    "app.controllers"
    "app.factories"
    "app.services"
    "app.factories"
    "app.directives"
    "app.filters"
    "app.config"
    "pascalprecht.translate"
    "ngToast"
    "ngAnimate"
    "ngResource"
    "ngSanitize"
    "ngCookies"
    "logglyLogger"
]

app.run [
    "$rootScope"
    "$state"
    "$stateParams"
    "$http"
    "$location"
    "$cookieStore"
    "$log"
    ( $rootScope, $state, $stateParams, $http, $location, $cookieStore, $log) ->
        $rootScope.$state = $state
        $rootScope.$stateParams = $stateParams
        $rootScope.apiBase = "http://localhost:3000"
        $rootScope.apiVersion = "/v0"

        $rootScope.globals = $cookieStore.get( "globals" ) or {}
        if Object.keys($rootScope.globals).length > 0
            $rootScope.globals.authorized = true

        $rootScope.history = []
        $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
            $log.info "App run stateChangeSuccess called"
            $log.debug
                toState: toState
                toParams: toParams
                fromState: fromState
                fromParams: fromParams

            if $rootScope.history.length > 20
                $rootScope.history.splice(0, 1)

            $rootScope.history.push
                name: fromState.name
                params: fromParams
]

app.config [
    "$urlRouterProvider"
    "$stateProvider"
    "$locationProvider"
    "$httpProvider"
    "$translateProvider"
    "ngToastProvider"
    "LogglyLoggerProvider"
    "CONFIG"
    ( $urlRouterProvider, $stateProvider, $locationProvider, $httpProvider, $translateProvider, ngToast, LogglyLoggerProvider , CONFIG ) ->
        $locationProvider.html5Mode true

        # Loggly Configuration
        LogglyLoggerProvider.inputToken CONFIG.TOKEN.LOGGLY if CONFIG.TOKEN.LOGGLY

        # Set the logging level for messages sent to Loggly.  'DEBUG' sends all log messages.
        # @method level
        LogglyLoggerProvider.level "DEBUG"

        # Send console error stack traces to Loggly.
        # @method sendConsoleErrors
        LogglyLoggerProvider.sendConsoleErrors true

        # Toggle logging to console. When set to false, messages will not be be passed along to the original $log methods.
        # This makes it easy to keep sending messages to Loggly in production without also sending them to the console.
        # @method logToConsole
        LogglyLoggerProvider.logToConsole false unless CONFIG.ENV is "develop"

        # $location.absUrl() is sent as a "url" key in the message object that's sent to loggly
        # @method includeUrl
        LogglyLoggerProvider.includeUrl  true


        # I18N
        $translateProvider.useSanitizeValueStrategy "escape"
        $translateProvider.preferredLanguage "de"
        $translateProvider.fallbackLanguage "de"
        $translateProvider.useStaticFilesLoader
            prefix: "languages/"
            suffix: ".json"


        ngToast.configure(
            animation: "slide"
            dismissButton: true
            additionalClasses: "custom-backgrounds"
        )

        $stateProvider
        # abstract state for language as parameter in URL
        .state "app",
            abstract: true
            url: "/{locale}"
            controller: "AppCtrl"
            template: "<ui-view/>"

        # /
        .state "app.index",
            url: "/"
            templateUrl: "index/index.html"

        # /profile
        .state "app.profile",
            url: "/profile"
            templateUrl: "profile/profile.html"
            title: "profile"

        # /dataset detail-view
        .state "app.dataset-detail",
            url: "/dataset-detail"
            controller: "DetailCtrl"
            templateUrl: "datasets/detail-view.html"
            title: "detail-view"

        # /registration
        .state "app.registration",
            url: "/registration"
            controller: "RegistrationCtrl"
            templateUrl: "registration/registration.html"
            title: "registration"

        # /login
        .state "app.login",
            url: "/login"
            controller: "LoginCtrl"
            templateUrl: "login/login.html"
            title: "login"

        # /import
        .state "app.import",
            url: "/import"
            templateUrl: "import/import.html"
            controller: "ImportCtrl"
            title: "import"

        # /editor
        .state "app.editor",
            url: "/editor"
            templateUrl: "editor/editor.html"
            controller: "EditorCtrl"
            title: "editor"

        # not match was found in the states before (e.g. no language was provided in the URL)
        .state "noMatch",
            url: '*path'
            onEnter: ($state, $stateParams) ->
                locale =
                    locale: $translateProvider.preferredLanguage()

                # iterate over all states and check if the requested url exists as a state
                $state.get().forEach (state) ->
                    if $stateParams.path is state.url
                        $state.go state.name, locale

]

