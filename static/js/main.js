var hmData = {};
$(function(){

var dataRef = new Firebase('https://hypeapp.firebaseio.com');
dataRef.on('value', function(snapshot) {
    console.log('Hype: ' + snapshot.val());
});


    // heatmap configuration
    var heatmap$ = document.getElementById("heatmapArea");
    var canvas$ = document.getElementById("canvas");
    var radius = 50;
    var config = {
        element: heatmap$,
        radius: radius,
        opacity: 80
    };

    var W = canvas$.width, * Math.random() + radius,
        H = canvas$.height * Math.random() + radius;

    //creates and initializes the heatmap
    var heatmap = h337.create(config);

    var dataRef = new Firebase('https://hypeapp.firebaseio.com');
    dataRef.on('value', function(snapshot) {
        var val = snapshot.val();
        console.log(val);
        var hmData = {
            max: 100,
            data: [
                { x: W,
                  y: H,
                  count: val*0.5 }
            ]
        };
        $("#hypeScore").text(val);
        heatmap.store.setDataSet(hmData);
    });
});


