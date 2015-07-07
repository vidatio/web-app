gulp = require("gulp-help")(require("gulp"))
coffee = require "gulp-coffee"
coffeelint = require "gulp-coffeelint"
jade = require "gulp-jade"
templateCache = require "gulp-angular-templatecache"
concat = require "gulp-concat"
uglify = require "gulp-uglify"
gif = require "gulp-if"
karma = require "gulp-karma"
debug = require "gulp-debug"
copy = require "gulp-copy"
del = require "del"
connect = require "gulp-connect"
stylus = require "gulp-stylus"
rename = require "gulp-rename"
shell = require "gulp-shell"
sourcemaps = require 'gulp-sourcemaps'
gutil = require "gulp-util"
cache = require "gulp-cached"
{protractor} = require "gulp-protractor"

DOC_FILES = [
    "./README.MD"
    "./app/init-deps.coffee"
    "./app/app.coffee"
    "./app/app-controller.coffee"
    "./app/**/*.coffee"
    "!./app/**/*-test.coffee"
    "!./app/**/*-e2e.coffee"
]

COPY_FILES =
    img: "./app/statics/assets/images/**/*.*"
    fonts: [
        "./app/statics/assets/fonts/*.*"
        "./bower_components/bootstrap/dist/fonts/*.*"
    ]

BASEURL = "http://localhost:3123"

E2E_FILES = "./app/**/*-e2e.coffee"

APP_FILES = "./app/**/*.coffee"

BUILD =
    source:
        coffee: [
            "./app/init-deps.coffee"
            "./app/app.coffee"
            "./app/app-controller.coffee"
            "./app/**/*.coffee"
            "!./app/**/*-test.coffee"
            "!./app/**/*-e2e.coffee"
        ]
        stylus: [
            "./app/statics/master.styl"
        ]
        jade: [
            "./app/**/*.jade"
        ]
        html: [
            "./build/html/**/*.html"
        ]
    plugins:
        js: [
            "./bower_components/jquery/dist/jquery.js"
            "./bower_components/angular/angular.js"
            "./bower_components/angular-route/angular-route.js"
            "./bower_components/angular-resource/angular-resource.js"
            "./bower_components/angular-animate/angular-animate.js"
            "./bower_components/angular-cookies/angular-cookies.js"
            "./bower_components/angular-bootstrap/ui-bootstrap-tpls.js"
            "./bower_components/angular-ui-router/release/angular-ui-router.js"
            "./bower_components/handsontable/dist/handsontable.full.js"
            "./bower_components/nghandsontable/dist/ngHandsontable.js"
            "./bower_components/leaflet/dist/leaflet.js"
            "./bower_components/angular-leaflet-directive/dist/angular-leaflet-directive.js"
            "./bower_components/bootstrap/dist/js/bootstrap.js"
        ]
        css: [
            "./bower_components/handsontable/dist/handsontable.full.css"
            "./bower_components/leaflet/dist/leaflet.css"
            "./bower_components/bootstrap/dist/css/bootstrap.min.css"
            "./bower_components/bootstrap/dist/css/bootstrap.css.map"
        ]
    dirs:
        out: "./build"
        js: "./build/js"
        css: "./build/css"
        html: "./build/html"
        fonts: "./build/fonts"
        images: "./build/images"
        docs: "./docs"
    module: "app"
    app: "app.js"
    plugin:
        js: "plugins.js"
        css: "plugins.css"

WATCH = [
    "./app/init-deps.coffee"
    "./app/app.coffee"
    "./app/app-controller.coffee"
    "./app/**/*.coffee"
    "!./app/**/*-test.coffee"
    "!./app/**/*-e2e.coffee"
    "./app/**/*.jade"
    "./app/**/*.styl"
]

gulp.task "lint",
    "Lints all CoffeeScript source files.",
    ->
        gulp.src APP_FILES
        .pipe coffeelint()
        .pipe coffeelint.reporter()


gulp.task "test",
    "Starts and reruns all tests on change of test or source files.",
    ->
        gulp.src []
        .pipe karma
            configFile: "karma.conf.coffee"
            action: "watch"

gulp.task "e2e",
    "Runs all e2e tests.",
    [
        "run"
    ],
    ->
        gulp.src E2E_FILES
        .pipe protractor
            configFile: "./protractor.config.coffee"
            args: [
                "--baseUrl"
                BASEURL
            ]

gulp.task "build",
    "Lints and builds the project to '#{BUILD.dirs.out}'.",
    [
        "lint"
        "copy"
        "build:cache"
        "build:copy"
        "build:source:stylus"
        "build:source:coffee"
        "build:plugins:js"
        "build:plugins:css"
        "clean:html"
    ]

gulp.task "default",
    "Runs 'develop' and 'test'.",
    [
        "develop"
    ]

gulp.task "build:plugins:js",
    "Concatenates and saves '#{BUILD.plugin.js}' to '#{BUILD.dirs.js}'.",
    ->
        gulp.src BUILD.plugins.js
        .pipe cache("plugins.js")
        .pipe gif "*.js", concat(BUILD.plugin.js)
        .pipe gif "*.js", gulp.dest(BUILD.dirs.js)
        .pipe connect.reload()

gulp.task "build:plugins:css",
    "Concatenates and saves '#{BUILD.dirs.css}' to '#{BUILD.dirs.css}'.",
    ->
        gulp.src BUILD.plugins.css
        .pipe cache("plugins.css")
        .pipe gif "*.css", concat(BUILD.plugin.css)
        .pipe gif "*.css", gulp.dest(BUILD.dirs.css)
        .pipe connect.reload()

gulp.task "build:source:coffee",
    "Compiles and concatenates all coffeescript files to '#{BUILD.dirs.js}'.",
    ->
        gulp.src BUILD.source.coffee
        .pipe sourcemaps.init()
        .pipe coffee().on "error", gutil.log
        .pipe concat(BUILD.app)
        .pipe sourcemaps.write('./map')
        .pipe gulp.dest(BUILD.dirs.js)
        .pipe connect.reload()

gulp.task "build:source:stylus",
    "Compiles and concatenates all stylus files to '#{BUILD.dirs.css}'.",
    ->
        gulp.src BUILD.source.stylus
        .pipe sourcemaps.init()
        .pipe stylus
            compress: true
            linenos: true
        .pipe sourcemaps.write('./map')
        .pipe gulp.dest(BUILD.dirs.css)
        .pipe connect.reload()

gulp.task "build:source:jade",
    "Compiles and concatenates all jade files to '#{BUILD.dirs.html}'.",
    ->
        gulp.src BUILD.source.jade
        .pipe jade()
        .pipe gulp.dest(BUILD.dirs.html)
        .pipe connect.reload()


gulp.task "build:copy",
    "Copies master.html to '#{BUILD.dirs.out}/static'.",
    [
        "build:source:jade"
    ]
    ->
        gulp.src BUILD.source.html
        .pipe gif "**/master.html", gulp.dest ( BUILD.dirs.out )
        .pipe connect.reload()

gulp.task "build:cache",
    "Caches all angular.js templates in '#{BUILD.dirs.js}'.",
    [
        "build:source:jade"
    ]
    ->
        gulp.src BUILD.source.html
        .pipe templateCache(module: BUILD.module)
        .pipe gulp.dest ( BUILD.dirs.js )
        .pipe connect.reload()

gulp.task "build:watch",
    "Runs 'build' and watches the source files, rebuilds the project on change.",
    [
        "build"
    ],
    ->
        gulp.watch WATCH, ["build"]

gulp.task "develop",
    "Watches/Build and Test the source files on change.",
    [
        "build:watch"
        "test"
        "run"
    ]

gulp.task "dev",
    "Shorthand for develop.",
    [
        "develop"
    ]

gulp.task "copy",
    "Copy every assets to '#{BUILD.dirs.out}' dir.",
    [
        "copy:img"
        "copy:fonts"
    ]

gulp.task "copy:img",
    "Copy images to '#{BUILD.dirs.images}' dir.",
    ->
        gulp.src COPY_FILES.img
        .pipe gulp.dest BUILD.dirs.images

gulp.task "copy:fonts",
    "Copy fonts to '#{BUILD.dirs.fonts}' dir.",
    ->
        gulp.src COPY_FILES.fonts
        .pipe gulp.dest BUILD.dirs.fonts

gulp.task "clean",
    "Clear '#{BUILD.dirs.out}' and '#{BUILD.dirs.docs}' folder.",
    (cb) ->
        del [BUILD.dirs.out, BUILD.dirs.docs], -> cb null, []

gulp.task "clean:build",
    "Cleans the '#{BUILD.dirs.out}' directory",
    (cb) ->
        del BUILD.dirs.out, -> cb null, []

gulp.task "clean:docs",
    "Cleans the '#{BUILD.dirs.docs}' directory",
    (cb) ->
        del BUILD.dirs.docs, -> cb null, []

gulp.task "clean:html",
    "Cleans the '#{BUILD.dirs.html}' directory",
    [
        "build:copy"
    ]
    (cb) ->
        del BUILD.dirs.html, -> cb null, []

gulp.task "docs",
    "Generates documentation in '#{BUILD.dirs.docs}' directory.",
    ["clean:docs"], shell.task "groc"

serverStarted = false
gulp.task "run", "Serves the App.", ->
    return if serverStarted
    serverStarted = true

    connect.server
        root: BUILD.dirs.out
        livereload: true
        port: 3123
        fallback: BUILD.dirs.out + "/statics/master.html"
