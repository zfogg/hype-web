hype = angular.module("hypeApp", [
  "ngCookies"
  "ngResource"
  "ngSanitize"
  "ngAnimate"

  "ui.router"
  #"ui.bootstrap"
  "firebase"
])


  .config (
    $stateProvider,
    $urlRouterProvider,
    $locationProvider,
    $httpProvider) ->

    $locationProvider.html5Mode(true)

    $urlRouterProvider.otherwise "/404"

    $stateProvider
      .state "main",
        url: "/"
        templateUrl: "main/index.html"
        controller: "MainCtrl"

      .state "session",
        url: "/sesh/:sesh"
        templateUrl: "session/index.html"
        controller: "SessionCtrl"

      .state "login",
        abstract: true
        url: "/login"
        templateUrl: "login/index.html"
        controller: "LoginCtrl"
      .state "login.main",
        url: "?token&redirect"
        templateUrl: "login/login.html"
        controller: "LoginCtrl.main"

      .state "faq",
        url: "/faq"
        templateUrl: "faq/index.html"
        controller: "FaqCtrl"

      .state "register",
        abstract: true
        url: "/register"
        templateUrl: "register/index.html"
        controller: "RegisterCtrl"
      .state "register.one",
        url: ""
        templateUrl: "register/one.html"
        controller: "RegisterCtrl.one"

      .state "404",
        url: "/404"
        templateUrl: "layout/404/index.html"
        controller: "404Ctrl"


  .directive "scrollTo", ->
    (scope, element, attrs) ->
      element.bind "click", (event) ->
        location = attrs.scrollTo
        $.scrollTo location, +attrs.scrollSpeed or 300


  .controller "BodyCtrl", (
    $http,
    $scope,
    $rootScope,
    $window,
    $location,
    $timeout,
    $cookieStore,
    $resource,
    $state) ->

    $rootScope.isLoaded = true

    $rootScope.bodyCSS = {
      "transition": "background-color 0.4s ease-out"
    }

    $rootScope._login = (cookie) ->
      $rootScope.cookie = cookie
      $cookieStore.put "auth", cookie
      $http.defaults.headers
        .common["Authorization"] = "Token token=\"#{cookie.token}\""

    $rootScope._logout = ->
      $rootScope.cookie = null
      $cookieStore.put "auth", null
      delete $http.defaults.headers.common["Authorization"]

    $http.get("/api/hype")
      .success ->
        console.log "Looking for this? http://github.com/hype/hype"
        $("body").flowtype
          minimum   : 320
          maximum   : 1200
          minFont   : 17
          maxFont   : 22
          fontRatio : 40
          lineRatio : 1.45
      .error (data) ->
        null

    $rootScope.$on "$stateChangeSuccess", ->
      $window.scrollTo 0, 0
      $window.ga? "set", "page", $location.path()
      $window.ga? "send", "pageview"


  .factory "colors", ->
    "white"        : "#ffffff"
    "black"        : "#000000"
    "grey-light"   : "#e5d8cf"
    "grey"         : "#a58c7c"
    "grey-dark"    : "#7f6c60"
    "orange"       : "#ff6d40"
    "orange-dark"  : "#dd773d"
    "yellow"       : "#ffec40"
    "orangeyellow" : "#ffad40"
    "red"          : "#ff404a"
    "blue-light"   : "#ccf3ff"
    "blue-dark"    : "#538ca5"
    "blue-darker"  : "#1a2e3c"
    "green"        : "#53a559"
    "green-light"  : "#40997c"


  .factory "profile", ($resource) ->
    $resource("/api/profile", {}, {
      save:
        method: 'PUT'
    })

