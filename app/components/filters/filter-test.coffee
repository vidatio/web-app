"use strict"
describe "Filter Catalog", ->
    beforeEach ->
        module "app.filters"
        inject ($filter, $injector) ->
            @injector = $injector
            @filter = $filter

    describe "DateFilter", ->
        it "should be defined and included", ->
            expect(@filter('dateFilter')).toBeDefined()

        it "should filter input correctly between minimum and maximum date", ->
            input = [
                {
                    createdAt: new Date("2016-02-06")
                },
                {
                    createdAt: new Date("2016-02-08")
                }
            ]

            result = [
                {
                    createdAt: new Date("2016-02-06")
                }
            ]

            expect(@filter('dateFilter')(input, "2016-02-05", "2016-02-07")).toEqual(result)

        it "should filter input correctly from minimum date", ->
            input = [
                {
                    createdAt: new Date("2016-02-06")
                },
                {
                    createdAt: new Date("2016-02-08")
                }
            ]

            result = [
                {
                    createdAt: new Date("2016-02-08")
                }
            ]

            expect(@filter('dateFilter')(input, "2016-02-07")).toEqual(result)

        it "should filter input correctly to maximum date", ->
            input = [
                {
                    createdAt: new Date("2016-02-06")
                },
                {
                    createdAt: new Date("2016-02-08")
                }
            ]

            result = [
                {
                    createdAt: new Date("2016-02-06")
                }
            ]

            expect(@filter('dateFilter')(input, undefined, "2016-02-07")).toEqual(result)

    describe "CategoryFilter", ->
        it "should be defined and included", ->
            expect(@filter('categoryFilter')).toBeDefined()

        it "should filter input correctly with a cateory", ->
            input = [
                {
                    metaData:
                        category:
                            name: "category1"
                },
                {
                    metaData:
                        category:
                            name: "category2"
                }
            ]

            result = [
                {
                    metaData:
                        category:
                            name: "category2"
                }
            ]

            expect(@filter('categoryFilter')(input, "category2")).toEqual(result)

    xdescribe "MyVidatioFilter", ->
        it "should be defined and included", ->
            expect(@filter('myVidatioFilter')).toBeDefined()
