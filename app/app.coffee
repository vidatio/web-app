# Vidatio App
# ===========
"use strict"

app = angular.module "app", [
    "ui.router"
    "leaflet-directive"
    "app.controllers"
    "app.services"
    "app.directives"
    "app.filters"
    "app.config"
    "pascalprecht.translate"
    "ngToast"
    "ngAnimate"
    "ngSanitize"
    "logglyLogger"
]

app.run [
    "$rootScope"
    "$state"
    "$stateParams"
    "$http"
    "$location"
    "$log"
    ( $rootScope, $state, $stateParams, $http, $location, $log) ->
        $rootScope.$state = $state
        $rootScope.$stateParams = $stateParams
        $rootScope.apiBase = "http://localhost:3000"

        $log.warn( 'Test Logs to Loggly 1' )
        $log.debug( 'Test Logs to Loggly 2' )
        $log.info( 'Test Logs to Loggly 3' )
        $log.error( 'Test Logs to Loggly 4' )
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
    ( $urlRouterProvider, $stateProvider, $locationProvider, $httpProvider, $translateProvider, ngToast, LogglyLoggerProvider , CONFIG) ->
        $locationProvider.html5Mode true

        # Loggly Configuration
        LogglyLoggerProvider.inputToken CONFIG.TOKEN.LOGGLY

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
        .state "app.landingPage",
            url: "/"
            templateUrl: "index/index.html"

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

