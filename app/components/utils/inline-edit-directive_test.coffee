
"use strict"

describe "Testing util component 'InlineEdit' directive", ->

    $compile = undefined
    $scope = undefined
    inline_edit = undefined
    element = undefined

    beforeEach ->
        module "animals"
        inject ( _$compile_, _$rootScope_ ) ->
            $compile = _$compile_
            $scope = _$rootScope_.$new()

        $scope.form = {}
        $scope.form.element = {}
        element = angular.element """
                <inline-edit form-element="form.element">
                </inline-edit>
            """

        inline_edit = $compile( element )($scope)


    it "should contain a span element", ->
        expect( inline_edit.html() ).toContain "span"

    it "should contain a glyphicon-pencil class", ->
        expect( inline_edit.html() ).toContain "glyphicon-pencil"

    it "should contain a glyphicon-remove class", ->
        expect( inline_edit.html() ).toContain "glyphicon-remove"

    it "should contain a glyphicon-ok class", ->
        expect( inline_edit.html() ).toContain "glyphicon-ok"

    it "should contain a inline-edit class", ->
        expect( inline_edit.html() ).toContain "inline-edit"

    it "should set $scope.formElement.disabled to true", ->
        expect( $scope.form.element.disabled ).toBeTruthy()
