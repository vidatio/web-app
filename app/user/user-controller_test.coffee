# User Controller Test
# ====================

"use strict"

describe "Testing user controller", ->

    UserCtrl = undefined
    $scope = undefined

    beforeEach( ->
        module "app"
        inject( ($controller, $rootScope) ->
            $scope = $rootScope.$new()
            UserCtrl = $controller( "UserCtrl",
                $scope: $scope
            )
        )

        # fake the "user" form object (n/a)
        $scope.user = {}
        $scope.user.$setPristine = jasmine.createSpy "$setPristine"

    )

    it "should be present", ->
        expect(UserCtrl).toBeDefined()

    it "should have an UserService", ->
        expect($scope.UserService).toBeDefined()
