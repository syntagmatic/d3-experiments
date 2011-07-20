// From http://mkweb.bcgsc.ca/circos/guide/tables/
var data = [
    [11975,  5871, 8916, 2868],
    [ 1951, 10048, 2060, 6171],
    [ 8010, 16145, 8090, 8045],
    [ 1013,   990,  940, 6907]
  ];
var chord = d3.layout.chord()
  .padding(.05)
  .sortSubgroups(d3.descending)
  .matrix(data);

var w = 480,
    h = 480,
    r0 = Math.min(w, h) * .41,
    r1 = r0 * 1.1;

var fill = d3.scale.ordinal()
    .domain(d3.range(4))
    .range(["#000000", "#FFDD89", "#957244", "#F26223"]);

function drawTicks(chord, svg) {
  var ticks = svg.append("svg:g")
      .attr("class", "ticks")
      .attr("opacity", 0.1)
    .selectAll("g")
      .data(chord.groups)
    .enter().append("svg:g")
    .selectAll("g")
      .data(groupTicks)
    .enter().append("svg:g")
      .attr("transform", function(d) {
        return "rotate(" + (d.angle * 180 / Math.PI - 90) + ")"
            + "translate(" + r1 + ",0)";
      });

  svg.selectAll(".ticks")
    .transition()
      .delay(600)
      .attr("opacity", 1)

  ticks.append("svg:line")
      .attr({
        "x1": 1,
        "y1": 0,
        "x2": 5,
        "y2": 0,
        "stroke": "#000"
        });

  ticks.append("svg:text")
      .attr({
        "x": 8,
        "dy": ".35em",
        "text-anchor": function(d) {
            return d.angle > Math.PI ? "end" : null;
          },
        "transform": function(d) {
            return d.angle > Math.PI ? "rotate(180)translate(-16)" : null;
          }
        })
      .text(function(d) { return d.label; });

  return ticks;
}

function render(chord) {

  var svg = d3.select("#chart")
    .append("svg:svg")
      .attr({
        "width": w,
        "height": h
        })
    .append("svg:g")
      .attr("transform", "translate(" + w / 2 + "," + h / 2 + ")");

  svg.append("svg:g")
    .selectAll("path")
      .data(chord.groups)
    .enter().append("svg:path")
      .attr("class", "arcs")
      .style({
        "fill": function(d) { return fill(d.index); },
        "stroke": function(d) { return fill(d.index); }
        })
      .attr("d", d3.svg.arc().innerRadius(r0).outerRadius(r1))
      .on({
        "mouseover": fade(.1),
        "mouseout": fade(1)
        })
      .each(stash);

  drawTicks(chord, svg);

  svg.append("svg:g")
      .attr("class", "chord")
    .selectAll("path")
      .data(chord.chords)
    .enter().append("svg:path")
      .attr("d", d3.svg.chord().radius(r0))
      .style({
        "fill": function(d) { return fill(d.target.index); },
        "opacity": 1
        });

  return svg;
}

function removeTicks(chord, svg) {
  // remove ticks
  svg.selectAll(".ticks")
    .transition()
      .each("end", function() { redrawArcsAndChords(chord,svg); })
      .delay(700)
      .attr("opacity", 0.2)
      .remove();
}

function redrawArcsAndChords(chord, svg) {
  var arcs = svg.selectAll('.arcs')
      .data(chord.groups)
      .transition()
        .duration(1700)
      .attrTween("d", arcTween)
      .each(stash);

  window.b = svg.select('.chord').selectAll('path');

  var last = svg.select(".chord").selectAll("path")[0].length - 1

  svg.select(".chord")
    .selectAll("path")
      .data(chord.chords)
      .transition()
        .duration(1700)
      .attr("d", d3.svg.chord().radius(r0))
      .style({
        "fill": function(d) { return fill(d.target.index); },
        "opacity": 1
        })
      .each("end", function(d,i) { if (i == last) drawTicks(chord, svg) });
}

function rerender(chord, svg) {

  removeTicks(chord, svg);

}

var svg = render(chord);

function shuffle() {
  setTimeout(function() {

    // Modify chord matrix
    var old_data = data;
    data = [
      [ rand(), rand(), rand(), rand()],
      [ rand(), rand(), rand(), rand()],
      [ rand(), rand(), rand(), rand()],
      [ rand(), rand(), rand(), rand()]
    ];
    chord
    .matrix(data);

    rerender(chord, svg);
    //render(chord);
    setTimeout(function() {
      shuffle();
    }, 4000);
  }, 600);
}

// Begin transition loop
shuffle();

function rand() {
  return 10000*Math.random();
}

// Stash the old values for transition.
function stash(d) {
  d.startAngle0 = d.startAngle;
  d.endAngle0 = d.endAngle;
}

// Doesn't actually tween
function arcTween(d, i, a) {
  var i = d3.interpolate({startAngle: a.startAngle0, endAngle: a.endAngle0}, a);
  return function(t) {  
    var b = i(t);
    var arc = d3.svg.arc()
      .startAngle(b.startAngle)
      .endAngle(b.endAngle)
      .innerRadius(r0)
      .outerRadius(r1);
    return arc;
  }
}

/** Returns an array of tick angles and labels, given a group. */
function groupTicks(d) {
  var k = (d.endAngle - d.startAngle) / d.value;
  return d3.range(0, d.value, 1000).map(function(v, i) {
    return {
      angle: v * k + d.startAngle,
      label: i % 5 ? null : v / 1000 + "k"
    };
  });
}

/** Returns an event handler for fading a given chord group. */
function fade(opacity) {
  return function(g, i) {
    svg.selectAll("g.chord path")
        .filter(function(d) {
          return d.source.index != i && d.target.index != i;
        })
      .transition()
        .style("opacity", opacity);
  };
}
    
