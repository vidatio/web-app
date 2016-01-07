class Logger
    constructor: () ->
        window.vidatio._LTracker = window.vidatio._LTracker or []

        _LTracker.push
            'logglyKey': CONFIG.TOKEN.LOGGLY
            'sendConsoleErrors': true
            'tag': 'loggly-jslogger'
    info: (message) ->
        _LTracker.push({
            'text': 'Hello World',
            'aList': [9, 2, 5],
            'anObject': {
                'id': 1,
                'value': 'foobar'
            }
        });
