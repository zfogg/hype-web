angular.module('hypeApp')
  .controller 'MainCtrl', ($scope, $rootScope, colors, $firebase) ->
    $rootScope.bodyCSS["background-color"] = colors["blue-light"]
    $rootScope.bodyCSS["transition"] = "background-color 0.5s ease-in"
    null

