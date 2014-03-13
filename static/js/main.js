var hmData = {};

$(function(){

    var dataRef = new Firebase('https://hypeapp.firebaseio.com');

    dataRef.on('value', function(snapshot) {
        console.log('Hype: ' + snapshot.val());
    });

    var heatmap$ = document.getElementById("heatmapArea"),
        canvas$  = document.getElementById("canvas"),

        config = {
            element: heatmap$,
            radius:  radius,
            opacity: 80
        },

        W       = canvas$.width  * Math.random() + config.radius,
        H       = canvas$.height * Math.random() + config.radius,
        heatmap = h337.create(config);


    dataRef.on('value', function(snapshot) {
        var obj     = snapshot.val(),
            data    = [],
            i       = 0,
            hypeSum = 0;

        for (var key in obj) {
            if (obj.hasOwnProperty(key)) {
                hypeSum += obj[key];
                data.push({
                    x: (100*i++), y: 400,
                    count: val*0.5
                });
            }
        }

        $("#hypeScore").text(hypeSum);

        heatmap.store.setDataSet({
            max:  100,
            data: data
        });

    });
});


