"use strict"

app = angular.module("app.controllers")

app.controller "ProfileCtrl", [
    "$scope"
    ($scope) ->

        $scope.vidatios = [
            {
                title: "Geburtenrate in Salzburg"
                image: "http://stephboreldesign.com/wp-content/uploads/2012/03/lorem-ipsum-logo.jpg"
                data: ""
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur."
            },
            {
                title: "Atomunfälle in Europa"
                image: "http://stephboreldesign.com/wp-content/uploads/2012/03/lorem-ipsum-logo.jpg"
                data: ""
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur."
            },
            {
                title: "Anzahl der Studenten pro Jahrgang"
                image: "http://stephboreldesign.com/wp-content/uploads/2012/03/lorem-ipsum-logo.jpg"
                data: ""
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur."
            },
            {
                title: "Einkünfte von Vidatio"
                image: "http://stephboreldesign.com/wp-content/uploads/2012/03/lorem-ipsum-logo.jpg"
                data: ""
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur."
            }
        ]

]
