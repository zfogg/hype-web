$(function(){

    // heatmap configuration
    var config = {
        element: document.getElementById("heatmapArea"),
        radius: 30,
        opacity: 50
    };

    //creates and initializes the heatmap
    var heatmap = h337.create(config);

    // let's get some data
    var data = {
        max: 20,
        data: [
            { x: 10, y: 20, count: 18 },
            { x: 25, y: 25, count: 14 },
            { x: 50, y: 30, count: 20 }
        ]
    };

    heatmap.store.setDataSet(data);
});
