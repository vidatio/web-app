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
    "datePicker"
    "colorpicker.module"
]

app.run [
    "$rootScope"
    "$state"
    "$stateParams"
    "$http"
    "$location"
    "$cookieStore"
    "CONFIG"
    "$translate"
    ( $rootScope, $state, $stateParams, $http, $location, $cookieStore, CONFIG, $translate) ->
        $rootScope.$state = $state
        $rootScope.$stateParams = $stateParams

        if CONFIG.ENV is "production"
            $rootScope.apiBase = "https://api.vidatio.com"
            $rootScope.apiVersion = "/v0"
        else
            $rootScope.apiBase = "http://localhost:3000"
            $rootScope.apiVersion = "/v0"

        window.vidatio.log = new vidatio.Logger(CONFIG.TOKEN.LOGGLY, CONFIG.ENV is "develop")
        window.vidatio.helper = new window.vidatio.Helper()
        window.vidatio.recommender = new window.vidatio.Recommender()
        window.vidatio.geoParser = new window.vidatio.GeoParser()

        $rootScope.globals = $cookieStore.get( "globals" ) or {}
        if Object.keys($rootScope.globals).length > 0
            $rootScope.globals.authorized = true
            $http.defaults.headers.common["Authorization"] = "Basic " + $rootScope.globals.currentUser.authData

        $rootScope.history = []
        $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
            if toState.title?
                $rootScope.title = toState.title
            else
                $translate("SLOGAN").then (slogan) ->
                    $rootScope.title = slogan

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
    "$provide"
    ( $urlRouterProvider, $stateProvider, $locationProvider, $httpProvider, $translateProvider, ngToast, LogglyLoggerProvider , CONFIG, $provide) ->
        $locationProvider.html5Mode true
        # Loggly Configuration
        # $log for angular
        LogglyLoggerProvider.inputToken CONFIG.TOKEN.LOGGLY if CONFIG.TOKEN.LOGGLY

        # Set the logging level for messages sent to Loggly.  'DEBUG' sends all log messages.
        # @method level
        LogglyLoggerProvider.level "INFO"

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

        # I18N for datepicker
        moment().locale "de"

        # overwrite default mFormat filter of datepicker module
        $provide.decorator 'mFormatFilter', ->
            (m, format, tz) ->
                if !moment.isMoment(m)
                    return ''
                if tz then moment.tz(m, tz).format(format) else m.format(format)


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

        .state "app.index",
            url: "/"
            templateUrl: "index/index.html"

        .state "app.imprint",
            url: "/imprint"
            templateUrl: "imprint/imprint.html",
            title: "imprint"

        .state "app.profile",
            url: "/profile"
            templateUrl: "profile/profile.html"
            title: "profile"

        .state "app.dataset",
            url: "/vidatio/:id"
            templateUrl: "dataset/dataset.html"
            controller: "DatasetCtrl"
            title: "dataset"

        .state "app.registration",
            url: "/registration"
            templateUrl: "registration/registration.html"
            controller: "RegistrationCtrl"
            title: "registration"

        .state "app.login",
            url: "/login"
            templateUrl: "login/login.html"
            controller: "LoginCtrl"
            title: "login"

        .state "app.import",
            url: "/import"
            templateUrl: "import/import.html"
            controller: "ImportCtrl"
            title: "import"

        .state "app.editor",
            url: "/editor"
            templateUrl: "editor/editor.html"
            controller: "EditorCtrl"
            title: "editor"

        .state "app.editor.id",
            url: "/editor/:id"
            templateUrl: "editor/editor.html"
            controller: "EditorCtrl"
            title: "editor"

        .state "app.share",
            url: "/share"
            templateUrl: "share/share.html"
            controller: "ShareCtrl"
            title: "share"

        .state "app.share.id",
            url: "/share/:id"
            templateUrl: "share/share.html"
            controller: "ShareCtrl"
            title: "share"

        .state "app.catalog",
            url: "/catalog?from&to&category&tags&myvidatios"
            templateUrl: "catalog/catalog.html"
            controller: "CatalogCtrl"
            title: "catalog"

        # not match was found in the states before (e.g. no language was provided in the URL)
        .state "noMatch",
            url: '*path'
            onEnter: ($state, $stateParams) ->
                # TODO: show 404

                locale =
                    locale: $translateProvider.preferredLanguage()

                # iterate over all states and check if the requested url exists as a state
                $state.get().forEach (state) ->
                    if $stateParams.path is state.url
                        $state.go state.name, locale

]
