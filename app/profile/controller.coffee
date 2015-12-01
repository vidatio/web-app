"use strict"

app = angular.module("app.controllers")

app.controller "ProfileCtrl", [
    "$scope"
    ($scope) ->

        $scope.vidatios = [
            {
                title: "Geburtenrate in Salzburg"
                image: "images/placeholder-featured-vidatios-arbeitslosenzahlen-salzburg.svg"
                data: ""
                id: 1
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur."
            },
            {
                title: "Atomunfälle in Europa"
                image: "images/placeholder-featured-vidatios-arbeitslosenzahlen-salzburg.svg"
                data: ""
                id: 2
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur."
            },
            {
                title: "Anzahl Studenten"
                image: "images/placeholder-featured-vidatios-arbeitslosenzahlen-salzburg.svg"
                data: ""
                id: 3
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur."
            }
        ]

]
