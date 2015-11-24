describe "Service User", ->
    beforeEach ->
        module "app"

        inject (UserService, $rootScope, Base64, $http) ->
            @rootScope = $rootScope
            @UserService = UserService
            @Base64 = Base64

            @http = $http
            @http.defaults.headers.common["Authorization"] = "Basic "

    it 'should have a user without name', ->
        expect(@UserService.user.name).toEqual("")

    it 'should set credentials on login', ->
        username = "test"
        password = "secret"

        @UserService.setCredentials username, password
        authData = @Base64.encode username + ":" + password

        expect(@rootScope.globals.currentUser.authData).toBeTruthy()
        expect(@rootScope.globals.currentUser.authData).toEqual(authData)

        expect(@http.defaults.headers.common.Authorization).toBeTruthy()
        expect(@http.defaults.headers.common.Authorization).toEqual("Basic " + authData)

    it 'should clear credentials on logout', ->
        @UserService.logout()

        expect(@UserService.user.name).toBeFalsy()
        expect(@UserService.user.name).toEqual("")
        expect(@rootScope.globals.currentUser).toBeFalsy()
        expect(@rootScope.globals.authorized).toBeFalsy()

        expect(@http.defaults.headers.common.Authorization).toBeTruthy()
        expect(@http.defaults.headers.common.Authorization).toEqual("Basic ")
