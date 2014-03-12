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

    var W = canvas$.width * Math.random() + radius,
    H = canvas$.height * Math.random() + radius;

    //creates and initializes the heatmap
    var heatmap = h337.create(config);

    dataRef.on('value', function(snapshot) {
        var obj = snapshot.val();

        var data = [];

        // http://stackoverflow.com/questions/684672/loop-through-javascript-object
        var i = 1;
        for (var key in obj) {
            if (obj.hasOwnProperty(key)) {
                i++;
                var val = obj[key];
                data.push({ x: 100 * i, y: 400, count: val*0.5 });
            }
        }

        var hmData = {
            max: 100,
            data: data
        };
        $("#hypeScore").text(val);
        heatmap.store.setDataSet(hmData);
    });
});


