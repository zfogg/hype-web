angular.module('hypeApp')
  .controller 'SessionCtrl', ($scope, $rootScope, colors, $firebase, $stateParams) ->
    $rootScope.bodyCSS["background-color"] = colors["grey-light"]

    $scope.params = $stateParams

    dataRef = new Firebase("https://hypeapp.firebaseio.com")
    dataRef.on "value", (snapshot) ->
      console.debug snapshot.val() if Math.random() > 0.9

    heatmap$ = $("#heatmapArea")[0]

    canvas$  = $("#canvas")[0]

    config =
      element: heatmap$
      radius:  40
      opacity: 100

    W = canvas$.width * Math.random() + config.radius
    H = canvas$.height * Math.random() + config.radius

    heatmap = h337.create(config)


    dataRef.on "value", (snapshot) ->
      obj = snapshot.val()
      i = 0
      hypeSum = 0

      data = for key of obj when obj.hasOwnProperty(key)
        hypeSum += obj[key]
        x: (150 * ++i)
        y: 100
        count: obj[key]

      $("#hypeScore").text hypeSum

      heatmap.store.setDataSet
        max: 650
        data: data

