module.exports = (grunt) ->

  require("load-grunt-tasks") grunt

  require("time-grunt") grunt


  grunt.initConfig
    hype:

      app:   "client"
      srv:   "server"

      tmp:   ".tmp"
      dist:  "public"


    express:
      options:
        cmd: "coffee"

      dev:
        options:
          script: "hype.coffee"
          node_env: "development"
          port: process.env.PORT or 8000

      prod:
        options:
          script: "hype.coffee"
          node_env: "production"
          port: process.env.PORT or 80


    prettify:
      dist:
        expand: true
        cwd:  "<%= hype.dist %>"
        src:  "**/*.html"
        dest: "<%= hype.dist %>"

    watch:
      views_templates:
        files: [
          "<%= hype.app %>/**/*.jade",
          "!<%= hype.app %>/index.jade"
        ]
        tasks: [ "newer:jade:templates" ]
      views_index:
        files: [ "<%= hype.app %>/index.jade" ]
        tasks: [ "newer:jade:index" ]

      scripts:
        files: ["<%= hype.app %>/**/*.coffee"]
        tasks: ["newer:coffee:dist"]

      styles:
        files: ["<%= hype.app %>/**/*.sass"]
        tasks: [ "compass:dev", "autoprefixer" ]

      livereload_css:
        options: livereload: true
        files: [ "<%= hype.tmp %>/**/*.css" ]

      livereload_else:
        options: livereload: true
        files: [
          "<%= hype.dist %>/index.html"
          "<%= hype.tmp %>/**/*.html"
          "<%= hype.tmp %>/**/*.js"
        ]

      express:
        files: [ "<%= hype.srv %>/**/*.coffee", "hype.coffee" ]
        tasks: ["express:dev"]
        options:
          livereload: true
          nospawn:    true

      css:
        files: ["<%= hype.app %>/**/*.css"]
        tasks: [ "newer:copy:styles_tmp", "autoprefixer" ]

      gruntfile: files: ["Gruntfile.{js,coffee}"]


    clean:
      dist:
        files: [
          dot: true
          src: [
            "<%= hype.tmp %>/*"
            "<%= hype.dist %>/*"
          ]
        ]


    jade:
      index:
        expand: true
        cwd:    "<%= hype.app %>"
        src:    [ "index.jade" ]
        dest:   "<%= hype.dist %>"
        ext:    ".html"
      templates:
        expand: true
        cwd:    "<%= hype.app %>"
        src:    [ "**/*.jade", "!index.jade" ]
        dest:   "<%= hype.tmp %>"
        ext:    ".html"


    autoprefixer:
      options: browsers: ["last 1 version"]
      dist:
        expand: true
        cwd:    "<%= hype.tmp %>"
        src:    [ "**/*.css" ]
        dest:   "<%= hype.tmp %>"


    coffee:
      dist:
        options: sourceMap: false
        files: [
          expand: true
          cwd:  "<%= hype.app %>"
          src:  "**/*.coffee"
          dest: "<%= hype.tmp %>"
          ext: ".js"
        ]
      dev:
        options:
          sourceMap: true
          sourceRoot: ""
        files: "<%= coffee.dist.files %>"


    compass:
      options:
        sassDir:                 "<%= hype.app %>"
        cssDir:                  "<%= hype.tmp %>"
        imagesDir:               "<%= hype.app %>"
        javascriptsDir:          "<%= hype.app %>"
        fontsDir:                "<%= hype.app %>"
        importPath:              "components"
        httpImagesPath:          "/images"
        httpFontsPath:           "/fonts"
        relativeAssets:          false
        assetCacheBuster:        false

      prod: options: debugInfo: false
      dev:  options: debugInfo: true
      watch:
        debugInfo: false
        watch:     true


    rev:
      dist:
        src: [
          "<%= hype.dist %>/**/*.js"
          "<%= hype.dist %>/**/*.css"
          "<%= hype.dist %>/**/*.{png,jpg,jpeg,gif,webp,svg}"
          "!<%= hype.dist %>/**/opengraph.png"
        ]


    useminPrepare:
      options: dest: "public"
      html: "<%= hype.dist %>/index.html"


    usemin:
      options: assetsDirs: "<%= hype.dist %>"
      html: [ "<%= hype.dist %>/**/*.html" ]
      css:  [ "<%= hype.dist %>/**/*.css" ]


    usebanner:
      options:
        position: "top"
        banner: require "./ascii"
      files:  [ "<%= hype.dist %>/index.html" ]


    ngmin:
      dist:
        expand: true
        cwd:  "<%= hype.tmp %>"
        src:  "**/*.js"
        dest: "<%= hype.tmp %>"


    copy:
      styles_tmp:
        expand: true
        cwd:  "<%= hype.app %>"
        src:  "**/*.css"
        dest: "<%= hype.tmp %>"
      components_dist:
        expand: true
        src:  [ "components/**" ]
        dest: "<%= hype.dist %>"
      app_dist:
        expand: true
        cwd: "<%= hype.app %>"
        dest: "<%= hype.dist %>"
        src: [
          "*.{ico,txt}"
          "images/**/*"
          "fonts/**/*"
        ]


    inject:
      googleAnalytics:
        scriptSrc: "<%= hype.app %>/ga.js"
        files:
          "<%= hype.dist %>/index.html": "<%= hype.dist %>/index.html"


    concurrent:
      dist1_dev: [
        "compass:dev"
        "coffee:dev"
        "copy:styles_tmp"
      ]
      dist1: [
        "jade"
        "compass:prod"
        "coffee:dist"
        "copy:styles_tmp"
      ]
      dist2: [
        "ngmin"
        "autoprefixer"
      ]
      dist3: [
        "copy:app_dist"
        "copy:components_dist"
        "inject:googleAnalytics"
      ]
      watch:
        options: logConcurrentOutput: true
        tasks: [
          "watch"
          "compass:watch"
        ]


    ngtemplates:
      hype:
        cwd:  "<%= hype.tmp %>"
        src:  [ "**/*.html", "!index.html" ]
        dest: "<%= hype.dist %>/scripts/templates.js"
        options:
          usemin: "scripts/main.js"



  grunt.registerTask "build", [
    "clean"

    "jade"
    "concurrent:dist1"

    "prettify"
    "useminPrepare"

    "concurrent:dist2"

    "ngtemplates"
    "concat:generated"

    "cssmin:generated"
    "uglify:generated"

    "usemin"

    "concurrent:dist3"
    "usebanner"
  ]


  grunt.registerTask "express-keepalive", -> @async()


  grunt.registerTask "serve", (target) ->
    if target is "dist"
      return grunt.task.run [
        "build"
        "express:prod"
        "express-keepalive"
      ]
    else
      return grunt.task.run [
        "clean"

        "jade"
        "concurrent:dist1_dev"

        "prettify"

        "autoprefixer"
        "useminPrepare"

        "concurrent:dist2"

        "express:dev"

        "concurrent:watch"
      ]


  grunt.registerTask "default", [
    "build"
  ]

