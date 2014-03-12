var hmData = {};
$(function(){

    // heatmap configuration
    var heatmap$ = document.getElementById("heatmapArea");
    var canvas$ = document.getElementById("canvas");
    var config = {
        element: heatmap$,
        radius: 280,
        opacity: 80
    };

    var W = canvas$.width,
        H = canvas$.height;


    //creates and initializes the heatmap
    var heatmap = h337.create(config);

    var dataRef = new Firebase('https://hypeapp.firebaseio.com');
    dataRef.on('value', function(snapshot) {
        var val = snapshot.val();
        console.log(val);
        var hmData = {
            max: 100,
            data: [
                { x: W*1.5,
                y:   H*2.0,
                count: val*0.5 }
            ]
        };
        $("#hypeScore").text(val);
        heatmap.store.setDataSet(hmData);
    });
});


