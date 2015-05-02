# Progress Directive
# ==================

"use strict"

app = angular.module "animals.directives"

app.directive "progressArcMask", ->
    restrict: "E"
    template: "<canvas width='300' height='300'></canvas>"
    link: ( $scope, $element, $attributes ) ->

        animationFrameId = undefined
        switchFrameId = 0

        canvas = $element[0].firstChild
        context = canvas.getContext "2d"

        counterClock = false

        startAngle = -.5
        endAngle = 1.5

        currentIteration = 0
        maxIterations = 100

        drawProgressArc = ->
            context.clearRect 0, 0, 300, 300
            context.beginPath()

            if counterClock
                value =
                    easeInOutCubic(
                        currentIteration, 0, 2, maxIterations ) - 0.5
                context.arc(
                    150, 150, 139, -0.5 * Math.PI, value * Math.PI, false )
            else
                value =
                    easeInOutCubic(
                        currentIteration, 0, 2, maxIterations ) - 2.5
                context.arc(
                    150, 150, 139, value * Math.PI, -0.5 * Math.PI, false )
            context.lineWidth = 8
            context.strokeStyle = "#FFFFFF"
            context.stroke()

            currentIteration++

            if currentIteration is maxIterations
                currentIteration = 0
                counterClock = !counterClock

        animate = ->
            animationFrameId = requestAnimationFrame animate
            drawProgressArc()

        animate context


easeInOutCubic =
    (currentIteration, startValue, changeInValue, totalIterations) ->
        if (currentIteration /= totalIterations / 2) < 1
            return changeInValue / 2 * currentIteration ** 3 + startValue
        changeInValue / 2 * ((currentIteration - 2) ** 3 + 2) + startValue