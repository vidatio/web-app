class window.vidatio.Logger
    constructor: (TOKEN, sendToConsole) ->
        @sendToConsole = sendToConsole
        @_LTracker = @_LTracker or []
        @_LTracker.push
            'logglyKey': TOKEN
            'sendConsoleErrors': true
            'tag': 'loggly-jslogger'

    debug: (object) ->
        @_LTracker.push(object)
        console.log object if @sendToConsole

    info: (message) ->
        @_LTracker.push(message)
        console.info message if @sendToConsole

    error: (message) ->
        @_LTracker.push(message)
        console.error message if @sendToConsole

