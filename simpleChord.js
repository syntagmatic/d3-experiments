var stash = [];
var counter = false;

var data = [
    [11975,  5871, 8916, 2868],
    [ 1951, 10048, 2060, 6171],
    [ 8010, 16145, 8090, 8045],
    [ 1013,   990,  940, 6907]
  ];

var data2 = [
    [ 1975,  5871, 8916, 2868],
    [ 1951,  0048, 2060, 6171],
    [ 8010, 16145, 8090, 8045],
    [ 1013,   990,  940, 6907]
  ];

var chord = d3.layout.chord()
  .padding(.05)
  .sortSubgroups(d3.descending)
  .matrix(data);

var chord2 = d3.layout.chord()
  .padding(.05)
  .sortSubgroups(d3.descending)
  .matrix(data2);

var w = 480,
    h = 480,
    r0 = Math.min(w, h) * .41,
    r1 = r0 * 1.1;

var svg = render(chord);

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
        "fill": function(d) { return '#666'; },
        "stroke": function(d) { return '#999'; }
        })
      .attr("d", d3.svg.arc().innerRadius(r0).outerRadius(r1))
      .each(stash_arc);

  return svg;
};

/* Interactions*/

d3.select("#change").on("click", function() {
  svg.selectAll("path").data(chord2.groups)
      .transition()
      .duration(1500)
      .attrTween("d", arcTween); 

  counter = !counter;
});

/* Functions */

var arc =  d3.svg.arc()
      .startAngle(function(d) { return d.startAngle })
      .endAngle(function(d) { return d.endAngle })
      .innerRadius(r0)
      .outerRadius(r1);

function stash_arc(d, i, a) {
  stash[i] = d;
}

function arcTween(d, i, a) {
  if (counter) {
    var i = d3.interpolate(stash[i], d);
  } else {
    var i = d3.interpolate(d, stash[i]);
  }

  return function(t) {
    return arc(i(t));
  }
}

