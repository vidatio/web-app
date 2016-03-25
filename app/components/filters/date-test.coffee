"use strict"
describe "Filter Catalog", ->
    beforeEach ->
        module "ngCookies", "app.filters"
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
