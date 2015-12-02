"use strict"

app = angular.module("app.controllers")

app.controller "ProfileCtrl", [
    "$scope"
    "DataFactory"
    ($scope, DataFactory) ->
        $scope.vidatios = []

        DataFactory.query null, (response) ->
            for dataset in response
                $scope.vidatios.push
                    title: dataset.name
                    image: "images/placeholder-featured-vidatios-arbeitslosenzahlen-salzburg.svg"
                    data: dataset.data
                    id: dataset._id
                    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur."

                if $scope.vidatios.length >= 5
                    return

]
