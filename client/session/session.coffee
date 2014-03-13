angular.module('hypeApp')
  .controller 'SessionCtrl', ($scope, $rootScope, colors, $firebase, $stateParams) ->
    $rootScope.bodyCSS["background-color"] = colors["grey-light"]

    $scope.params = $stateParams

    $scope.hypeFactor = 0

    dataRef = new Firebase("https://hypeapp.firebaseio.com")
    dataRef.on "value", (snapshot) ->
      #console.debug snapshot.val() if Math.random() > 0.9

    heatmap$ = $("#heatmapArea")[0]

    canvas$  = $("#canvas")[0]

    config =
      element: heatmap$
      radius:  40
      opacity: 100

    W = canvas$.width
    H = canvas$.height

    heatmap = h337.create(config)


    hmF = (n) ->
      Math.log(n+1)

    dataRef.on "value", (snapshot) ->
      obj     = snapshot.val()
      i       = 0
      $scope.hypeFactor = 0

      data = for key of obj when obj.hasOwnProperty(key)
        d = obj[key]
        hypeScore = Math.max Math.abs(d.x), Math.abs(d.y), Math.abs(d.z)
        $scope.hypeFactor += hypeScore
        x: 380 + (++i*100)
        y: (H/2) - (config.radius/2)
        count: hmF(700*(hypeScore - 9.82))

      $scope.$apply -> $scope.hypeFactor = Math.floor $scope.hypeFactor

      heatmap.store.setDataSet
        max: 15
        data: data

