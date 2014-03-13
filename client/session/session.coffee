angular.module('hypeApp')
  .controller 'SessionCtrl', ($scope, $rootScope, colors, $firebase, $stateParams) ->
    $rootScope.bodyCSS["background-color"] = colors["grey-light"]

    $scope.params = $stateParams

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
    console.log W

    heatmap = h337.create(config)


    dataRef.on "value", (snapshot) ->
      obj     = snapshot.val()
      i       = 0
      hypeSum = 0

      data = for key of obj when obj.hasOwnProperty(key)
        d = obj[key]
        hypeScore = Math.max Math.abs(d.x), Math.abs(d.y), Math.abs(d.z)
        console.log hypeScore
        hypeSum += obj[key]
        x: (W/2) - (config.radius/2) + (++i*100)
        y: (H/2) - (config.radius/2)
        count: hypeScore

      $("#hypeScore").text hypeSum

      heatmap.store.setDataSet
        max: 20
        data: data

