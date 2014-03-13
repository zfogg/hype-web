angular.module('hypeApp')
  .controller 'SessionCtrl', ($scope, $rootScope, colors, $firebase, $stateParams, harlemshake) ->
    $rootScope.bodyCSS["background-color"] = colors["grey-light"]

    $scope.params = $stateParams

    $scope.hypeFactor = 0


    randomN = (min, max) ->
      Math.random() * (max - min) + min

    randomInt = (min, max) ->
      Math.floor(Math.random() * (max - min + 1)) + min

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

    spots = {}
    hyped = false
    dataRef.on "value", (snapshot) ->
      obj     = snapshot.val()
      i       = 0
      hypeSum = 0

      data = for key of obj when obj.hasOwnProperty(key)
        i++
        d = obj[key]

        if not spots[key]
          spots[key] =
            x: randomInt config.radius, ((W*4) - config.radius)
            y: randomInt config.radius, ((H*1) - config.radius)

        hypeScore = Math.max Math.abs(d.x), Math.abs(d.y), Math.abs(d.z)
        hypeSum += hypeScore
        #x: 380 + (++i*100)
        #y: (H/2) - (config.radius/2)
        x: spots[key].x
        y: spots[key].y
        count: hmF(700*(hypeScore - 9.82))

      $scope.$apply ->
        $scope.hypeFactor = Math.floor(hypeSum/i)
        if $scope.hypeFactor >= 11 and not hyped
          hyped = true
          harlemshake()

      heatmap.store.setDataSet
        max: 9
        data: data

