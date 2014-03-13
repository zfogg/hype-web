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


  .factory "harlemshake", ->
    ->
      c = ->
        e = document.createElement("link")
        e.setAttribute "type", "text/css"
        e.setAttribute "rel", "stylesheet"
        e.setAttribute "href", f
        e.setAttribute "class", l
        document.body.appendChild e
      h = ->
        e = document.getElementsByClassName(l)
        t = 0

        while t < e.length
          document.body.removeChild e[t]
          t++
      p = ->
        e = document.createElement("div")
        e.setAttribute "class", a
        document.body.appendChild e
        setTimeout (->
          document.body.removeChild e
        ), 100
      d = (e) ->
        height: e.offsetHeight
        width: e.offsetWidth
      v = (i) ->
        s = d(i)
        s.height > e and s.height < n and s.width > t and s.width < r
      m = (e) ->
        t = e
        n = 0
        until not t
          n += t.offsetTop
          t = t.offsetParent
        n
      g = ->
        e = document.documentElement
        unless not window.innerWidth
          return window.innerHeight
        else return e.clientHeight  if e and not isNaN(e.clientHeight)
        0
      y = ->
        return window.pageYOffset  if window.pageYOffset
        Math.max document.documentElement.scrollTop, document.body.scrollTop
      E = (e) ->
        t = m(e)
        t >= w and t <= b + w
      S = ->
        e = document.createElement("audio")
        e.setAttribute "class", l
        e.src = i
        e.loop = false
        e.addEventListener "canplay", (->
          setTimeout (->
            x k
          ), 500
          setTimeout (->
            N()
            p()
            e = 0

            while e < O.length
              T O[e]
              e++
          ), 15500
        ), true
        e.addEventListener "ended", (->
          N()
          h()
        ), true
        e.innerHTML = " <p>If you are reading this, it is because your browser does not support the audio element. We recommend that you get a new browser.</p> <p>"
        document.body.appendChild e
        e.play()
      x = (e) ->
        e.className += " " + s + " " + o
      T = (e) ->
        e.className += " " + s + " " + u[Math.floor(Math.random() * u.length)]
      N = ->
        e = document.getElementsByClassName(s)
        t = new RegExp("\\b" + s + "\\b")
        n = 0

        while n < e.length
          e[n].className = e[n].className.replace(t, "")
      e = 30
      t = 30
      n = 350
      r = 350
      i = "http://s3.amazonaws.com/moovweb-marketing/playground/harlem-shake.mp3"
      s = "mw-harlem_shake_me"
      o = "im_first"
      u = [
        "im_drunk"
        "im_baked"
        "im_trippin"
        "im_blown"
      ]
      a = "mw-strobe_light"
      f = "//s3.amazonaws.com/moovweb-marketing/playground/harlem-shake-style.css"
      l = "mw_added_css"
      b = g()
      w = y()
      C = document.getElementsByTagName("*")
      k = null
      L = 0

      while L < C.length
        A = C[L]
        if v(A)
          if E(A)
            k = A
            break
        L++
      if A is null
        console.warn "Could not find a node of the right size. Please try a different page."
        return
      c()
      S()
      O = []
      L = 0

      while L < C.length
        A = C[L]
        O.push A  if v(A)
        L++

