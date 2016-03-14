"use strict"

describe "Service Recommender", ->
    beforeEach ->
        @recommender = new window.vidatio.Recommender()
        @helper = new window.vidatio.Helper()

    it "should analyse type of the columns and so the schema of the dataset", ->
        schema = [["coordinate", "numeric"], ["coordinate", "numeric"], ["nominal"], ["nominal"],
            ["coordinate", "numeric"]]
        dataset = [
            ["47", "13", "Salzburg", "41,5%", "2"]
            ["46", "12", "Wien", "38,5%", "2"]
            ["46", "11", "Bregenz", "40,5%", "1"]
            ["49", "10", "Linz", "39,5%", "1"]
            ["49", "10", "Linz", "39,5%", "2"]
        ]
        dataset = @helper.transposeDataset(dataset)
        expect(@recommender.getSchema(dataset)).toEqual(schema)

    it "should analyse the variances of the columns of the dataset", ->
        variances = [0.5, 0.5, 0.25, 1]
        dataset = [
            ["47.349", "13.892", "Salzburg", "2%"]
            ["47.349", "13.892", "Salzburg", "3%"]
            ["46.323", "13.892", "Salzburg", "4%"]
            ["46.323", "10.348", "Salzburg", "5%"]
        ]
        dataset = @helper.transposeDataset(dataset)
        expect(@recommender.getVariances dataset).toEqual(variances)

        variances = [1, 1]
        dataset = [
            ["200", "Apfel"]
            ["300", "Banane"]
            ["400", "Kiwi"]
            ["500", "Orange"]
        ]
        dataset = @helper.transposeDataset(dataset)
        expect(@recommender.getVariances dataset).toEqual(variances)

    it "should recommend a map if there is a geo column header", ->
        header = ["X", "Y", "test", "City"]
        dataset = [
            ["47.349", "13.892", "Salzburg", "2%"]
            ["47.349", "13.892", "Salzburg", "3%"]
            ["46.323", "13.892", "Salzburg", "4%"]
            ["46.323", "10.348", "Salzburg", "5%"]
        ]

        expect(@recommender.run dataset, header).toEqual(
            "type": "map"
            "xColumn": 0
            "yColumn": 1
        )

        dataset = [
            ["47.349", "13.892", "Salzburg", "2%"]
            ["47.349", "13.892", "Salzburg", "3%"]
            ["46.321", "11.892", "Salzburg", "3%"]
            ["46.323", "10.348", "Salzburg", "3%"]
        ]

        expect(@recommender.run dataset).toEqual(
            "type": "map"
            "xColumn": 0
            "yColumn": 1
        )

        header = ["GEOMETRIE", "empty", "test", "City"]
        dataset = [
            ["47.349,13.892", "Salzburg", "2%", "2%"]
            ["47.349,13.892", "Salzburg", "3%", "2%"]
            ["46.323,13.892", "Salzburg", "4%", "2%"]
            ["46.323,10.348", "Salzburg", "5%", "2%"]
        ]

        expect(@recommender.run dataset, header).toEqual(
            "type": "map"
            "xColumn": 0
            "yColumn": 0
        )

    it "should analyse the best diagram type for a given dataset system", ->
        dataset = [
            ["200", "10", "Salzburg", "2%"]
            ["300", "11", "Salzburg", "3%"]
            ["400", "12", "Salzburg", "3%"]
            ["500", "13", "Salzburg", "3%"]
        ]
        expect(@recommender.run dataset).toEqual(
            "type": "scatter"
            "xColumn": 0
            "yColumn": 1
        )

        dataset = [
            ["200", "Salzburg", "2%"]
            ["300", "Salzburg", "3%"]
            ["400", "Salzburg", "3%"]
            ["500", "Salzburg", "3%"]
        ]
        expect(@recommender.run dataset).toEqual(
            "type": "bar"
            "xColumn": 2
            "yColumn": 0
        )

        dataset = [
            ["200", "Apfel"]
            ["300", "Banane"]
            ["400", "Kiwi"]
            ["500", "Orange"]
        ]
        expect(@recommender.run dataset).toEqual(
            "type": "bar"
            "xColumn": 1
            "yColumn": 0
        )

        dataset = [
            [100, "2015-01-01"]
            [200, "2014-01-01"]
            [300, "2013-01-01"]
        ]
        expect(@recommender.run dataset).toEqual(
            "type": "timeseries"
            "xColumn": 1
            "yColumn": 0
        )

        # NUMERIC, NUMERIC WITH SCATTER
        dataset = [
            [100, 200, "True", "11.222"]
            [10, 20, "True", "11.222"]
            [231, 132, "True", "11.222"]
            [144, 876, "True", "11.222"]
        ]

        expect(@recommender.run dataset).toEqual(
            "type": "scatter"
            "xColumn": 0
            "yColumn": 1
        )

        # NUMERIC, NUMERIC WITH PC
        dataset = []
        while dataset.length < 1000
            dataset.push [Math.random(), "1000", "True", "201.222"]

        expect(@recommender.run dataset).toEqual(
            "type": "parallel"
            "xColumn": 0
            "yColumn": 1
        )

        # NOMINAL, NOMINAL WITH SCATTER
        dataset = [
            ["Apfelsaft", "Linz", "Salzburg", "2%"]
            ["Apfelkuchen", "Innsbruck", "Salzburg", "3.213%"]
            ["Croissants", "Salzburg", "Salzburg", "3.122%"]
            ["Kaffee", "Wien", "Salzburg", "1.0%"]
        ]

        expect(@recommender.run dataset).toEqual(
            "type": "parallel"
            "xColumn": 0
            "yColumn": 1
        )

        # NOMINAL, NOMINAL WITH PC
        tmp = dataset.length
        while dataset.length < 501
            for i in [ 0...tmp ]
                dataset.push dataset[i]

        expect(@recommender.run dataset).toEqual(
            "type": "parallel"
            "xColumn": 0
            "yColumn": 1
        )

        # NOMINAL, NUMERIC WITH SCATTER
        dataset = [
            ["Apfel", 100]
            ["Birne", 200]
            ["Banane", 1200]
            ["Orange", 123]
            ["Balsamico", 213123]
            ["Olivenöl", 400]
            ["Erdbeeren", 10000]
            ["Fisch", 100]
            ["Pflaumen", 200]
            ["Wurst", 100]
        ]
        expect(@recommender.run dataset).toEqual(
            "type": "bar"
            "xColumn": 0
            "yColumn": 1
        )

        # NOMINAL, NUMERIC WITH SCATTER
        dataset.push ["Mango", 100]
        expect(@recommender.run dataset).toEqual(
            "type": "scatter"
            "xColumn": 0
            "yColumn": 1
        )

        # NOMINAL, NUMERIC WITH PC
        tmp = dataset.length
        while dataset.length < 501
            for i in [ 0...tmp ]
                dataset.push [dataset[i]]

        expect(@recommender.run dataset).toEqual(
            "type": "parallel"
            "xColumn": 0
            "yColumn": 1
        )

    it "should analyse the schema of the dataset with a 10% tolerance", ->

        # one column of each row has a failure
        schema = [["coordinate", "numeric"], ["coordinate", "numeric"], ["nominal"], ["nominal"], ["coordinate", "numeric"]]
        dataset = [
            ["test", "13", "Salzburg", "41,5%", "2"]
            ["46", "12", "Wien", "38,5%", "2"]
            ["46", "11", "Bregenz", "40,5%", "1"]
            ["46", "11", "Bregenz", "40,5%", "1"]
            ["46", "test", "Salzburg", "40,5%", "1"]
            ["49", "10", "Linz", "39,5%", "1"]
            ["49", "10", "Linz", "39,5%", "1"]
            ["49", "10", "Linz", "39,5%", "1"]
            ["49", "11", "Linz", "39,5%", "1"]
            ["49", "10", "1", "39", "Salzburg"]
        ]
        dataset = @helper.transposeDataset(dataset)
        expect(@recommender.getSchema(dataset)).toEqual(schema)

        # row has any failure
        schema = [["coordinate", "numeric"], ["date", "nominal"], ["nominal"], ["coordinate", "nominal"]]
        dataset = [
            ["56", "14.03.2016", "test", "N 47.123"]
            ["56", "14.03.2016", "test", "N 47.123"]
            ["56", "14.03.2016", "test", "N 47.123"]
            ["56", "14.03.2016", "test", "N 47.123"]
            ["56", "14.03.2016", "test", "N 47.123"]
            ["56", "14.03.2016", "test", "N 47.123"]
            ["56", "14.03.2016", "test", "N 47.123"]
            ["56", "14.03.2016", "test", "N 47.123"]
            ["56", "14.03.2016", "test", "N 47.123"]
            ["56", "14.03.2016", "test", "N 47.123"]
        ]
        dataset = @helper.transposeDataset(dataset)
        expect(@recommender.getSchema(dataset)).toEqual(schema)

        # dataset has more than 10% failures
        schema = [["coordinate", "numeric"], ["date", "nominal"], ["nominal"], ["coordinate", "nominal"]]
        dataset = [
            ["56", "14.03.2016", "test", "N 47.123"]
            ["56", "14.03.2016", "test", "N 47.123"]
            ["56", "14.03.2016", "test", "N 47.123"]
            ["56", "14.03.2016", "test", "N 47.123"]
            ["56", "14.03.2016", "test", "N 47.123"]
            ["56", "14.03.2016", "test", "N 47.123"]
            ["56", "14.03.2016", "test", "N 47.123"]
            ["56", "14.03.2016", "test", "N 47.123"]
            ["test", "test", "test", "47.123"]
            ["test", "test", "test", "47.123"]
        ]
        dataset = @helper.transposeDataset(dataset)
        expect(@recommender.getSchema(dataset)).not.toEqual(schema)
