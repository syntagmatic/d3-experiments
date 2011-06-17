$('body').append '<button id="stream_update"">Update</button>'

require ["../d3/d3.layout.js"], ->
  `
  /* Inspired by Lee Byron's test data generator. */
  function stream_layers(n, m, o) {
    if (arguments.length < 3) o = 0;
    function bump(a) {
      var x = 1 / (.1 + Math.random()),
          y = 2 * Math.random() - .5,
          z = 10 / (.1 + Math.random());
      for (var i = 0; i < m; i++) {
        var w = (i / m - y) * z;
        a[i] += x * Math.exp(-w * w);
      }
    }
    return d3.range(n).map(function() {
        var a = [], i;
        for (i = 0; i < m; i++) a[i] = o + o * Math.random();
        for (i = 0; i < 5; i++) bump(a);
        return a.map(stream_index);
      });
  }

  /* Another layer generator using gamma distributions. */
  function stream_waves(n, m) {
    return d3.range(n).map(function(i) {
      return d3.range(m).map(function(j) {
          var x = 20 * j / m - i / 3;
          return 2 * x * Math.exp(-.5 * x);
        }).map(stream_index);
      });
  }

  function stream_index(d, i) {
    return {x: i, y: Math.max(0, d)};
  }
  `

  `
  var n = 20, // number of layers
      m = 200, // number of samples per layer
      data0 = d3.layout.stack().offset("wiggle")(stream_layers(n, m)),
      data1 = d3.layout.stack().offset("wiggle")(stream_layers(n, m)),
      color = d3.scale.category20b();

  var w = $('body').width(),
      h = 500,
      mx = m - 1,
      my = d3.max(data0.concat(data1), function(d) {
        return d3.max(d, function(d) {
          return d.y0 + d.y;
        });
      });

  var area = d3.svg.area()
      .x(function(d) { return d.x * w / mx; })
      .y0(function(d) { return h - d.y0 * h / my; })
      .y1(function(d) { return h - (d.y + d.y0) * h / my; });

  var vis = d3.select("body")
    .append("svg:svg")
      .attr("width", w)
      .attr("height", h);

  vis.selectAll("path")
      .data(data0)
    .enter().append("svg:path")
      .style("fill", function() { return color(Math.random()); })
      .attr("class", "stream")
      .attr("d", area);

  $('#stream_update').click(function() {
    d3.selectAll("path")
        .data(function() {
          var d = data1;
          data1 = data0;
          return data0 = d;
        })
      .transition()
        .duration(2500)
        .attr("d", area);
  });

  `
  return
