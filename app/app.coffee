# Animals App
# ===========
"use strict"

app = angular.module "app", [
    "ngRoute"
    "ngResource"
    "ngAnimate"
    "ngCookies"
    "ngHandsontable"
    "ui.router"
    "ui.bootstrap"
    "app.controllers"
    "app.services"
    "app.directives"
    "app.filters"
]

app.run [
    "$rootScope"
    "$state"
    "$stateParams"
    "$http"
    "$cookieStore"
    "$location"
    "AuthenticationService"
    "UserService"
    ( $rootScope, $state, $stateParams, $http, $cookieStore, $location, AuthenticationService, UserService ) ->
        # $rootScope.state = $state
        # $rootScope.stateParams = $stateParams

        # $rootScope.globals = $cookieStore.get( "globals" ) or {}

        # if $rootScope.globals.currentUser
        #     AuthenticationService.SetExistingCredentials $rootScope.globals.currentUser
        #     UserService.init $rootScope.globals.currentUser.name

        # $rootScope.$on "$stateChangeStart", ( event, next, current ) ->
        #     unless next.name is "landingPage"
        #         unless $rootScope.globals.currentUser
        #             event.preventDefault()
        #             $state.go "landingPage"
]

# ***
# ## Config
# > contains routing stuff only (atm)
# >
# > see
# > [angular docs](http://docs.angularjs.org/guide/dev_guide.services.$location)
# > for $locationProvider details
app.config [
    "$urlRouterProvider"
    "$stateProvider"
    "$locationProvider"
    "$httpProvider"
    ( $urlRouterProvider, $stateProvider, $locationProvider, $httpProvider ) ->
        $locationProvider.html5Mode true

        #$urlRouterProvider.otherwise "/"

        $stateProvider
# /
        .state "landingPage",
            url: "/"
            templateUrl: "landing-page/landing-page.html"

# /import
        .state "import",
            url: "/import"
            templateUrl: "import/import.html"
            controller: "ImportCtrl"

# /import
        .state "editor",
            url: "/editor"
            templateUrl: "editor/editor.html"
            controller: "DataTableCtrl"

# /penguins
        # .state "penguins",
        #     url: "/penguins"
        #     templateUrl: "penguins/penguins.html"
        #     controller: "PenguinCtrl"
        #     resolve:
        #         penguins: [
        #             "PenguinService"
        #             (PenguinService) ->
        #                 PenguinService.query()
        #         ]

# /penguins/new
        # .state "penguins.new",
        #     url: "/new"
        #     templateUrl: "penguins/penguins.new.html"
        #     controller: "PenguinCtrl"

# /penguins/:penguin
        # .state "penguins.detail",
        #     url: "/:penguin"
        #     templateUrl: "penguins/penguin.detail.html"
        #     controller: "PenguinCtrl"
        #     resolve:
        #         penguin: [
        #             "PenguinService"
        #             "$stateParams"
        #             (PenguinService, $stateParams) ->
        #                 PenguinService.get $stateParams.penguin
        #         ]
]
