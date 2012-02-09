var arcs = [],
    chords = [];
var counter = false;

var data = [
    [11975,  5871, 8916, 2868],
    [ 1951, 10048, 2060, 6171],
    [ 8010, 16145, 8090, 8045],
    [ 1013,   990,  940, 6907]
  ];

var data2 = [
    [ rand(),  rand(), rand(), rand()],
    [ rand(),  rand(), rand(), rand()],
    [ rand(),  rand(), rand(), rand()],
    [ rand(),  rand(), rand(), rand()]
  ];

var chord = d3.layout.chord()
  .padding(.05)
  .matrix(data);

var chord2 = d3.layout.chord()
  .padding(.05)
  .matrix(data2);

var fill = d3.scale.ordinal()
    .domain(d3.range(4))
    .range(["#000000", "#FFDD89", "#7f7c79", "#3399bb"]);

var w = 480,
    h = 480,
    r0 = Math.min(w, h) * .41,
    r1 = r0 * 1.1;

var svg = render(chord);

/*** Interactions ***/

d3.select("#change").on("click", function() {
  // remove ticks and rerender
  svg.selectAll(".ticks")
    .transition()
      .each("end", function() { rerender(); })
      .duration(200)
      .attr("opacity", 0.1)
      .remove();
});

/*** Functions ***/

function render(chord) {
  // create svg
  var svg = d3.select("#chart")
    .append("svg:svg")
    .attr("width", w)
    .attr("height", h)
    .append("svg:g")
    .attr("transform", "translate(" + w / 2 + "," + h / 2 + ")");
 
  // draw arcs
  svg.append("svg:g")
     .selectAll("path")
     .data(chord.groups)
     .enter().append("svg:path")
     .attr("class", "arc")
     .style("fill", function(d) { return fill(d.index); })
     .style("stroke", function(d) { return fill(d.index); })
     .attr("d", d3.svg.arc().innerRadius(r0).outerRadius(r1))
     .each(stash_arc);

  // draw chords
  svg.append("svg:g")
     .attr("class", "chord")
     .selectAll("path")
     .data(chord.chords)
     .enter().append("svg:path")
     .attr("d", d3.svg.chord().radius(r0))
     .style("fill", function(d) { return fill(d.target.index); })
     .style("stroke", '#333')
     .style("opacity", 1)
     .each(stash_chord);

  drawTicks(chord,svg);

  return svg;
};

function rerender() {
  // update arcs
  svg.selectAll(".arc")
     .data(chord2.groups)
     .transition()
     .duration(1500)
     .attrTween("d", arcTween); 

  // used to time tick drawing
  var last = svg.select(".chord").selectAll("path")[0].length - 1

  // update chords
  svg.select(".chord")
     .selectAll("path")
     .data(chord2.chords)
     .transition()
     .duration(1500)
     .attrTween("d", chordTween)
     .each("end", function(d,i) {
       if (i == last) {
         if (counter) {
           drawTicks(chord2,svg);
         } else {
           drawTicks(chord,svg);
         }
       }
     });

  // flip active dataset
  counter = !counter;
}

function drawTicks(chord,svg) {
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
     .duration(700)
     .attr("opacity", 1)

  ticks.append("svg:line")
       .attr("x1", 1)
       .attr("y1", 0)
       .attr("x2", 5)
       .attr("y2", 0)
       .attr("stroke", '#000')

  ticks.append("svg:text")
       .attr("x", 8)
       .attr("dy", '.35em')
       .attr("text-anchor", function(d) {
             return d.angle > Math.PI ? "end" : null;
           })
       .attr("transform", function(d) {
             return d.angle > Math.PI ? "rotate(180)translate(-16)" : null;
           })
       .text(function(d) { return d.label; });

  return ticks;
}

var arc =  d3.svg.arc()
      .startAngle(function(d) { return d.startAngle })
      .endAngle(function(d) { return d.endAngle })
      .innerRadius(r0)
      .outerRadius(r1);

var chordl = d3.svg.chord().radius(r0);

function stash_arc(d,i) {
  arcs[i] = d;
}

function stash_chord(d,i) {
  chords[i] = d;
}

function arcTween(d,i) {
  if (counter) {
    var i = d3.interpolate(arcs[i], d);
  } else {
    var i = d3.interpolate(d, arcs[i]);
  }

  return function(t) {
    return arc(i(t));
  }
}

function chordTween(d,i) {
  if (counter) {
    var i = d3.interpolate(chords[i], d);
  } else {
    var i = d3.interpolate(d, chords[i]);
  }

  return function(t) {
    return chordl(i(t));
  }
}

// Returns an array of tick angles and labels, given a group.
function groupTicks(d) {
  var k = (d.endAngle - d.startAngle) / d.value;
  return d3.range(0, d.value, 1000).map(function(v, i) {
    return {
      angle: v * k + d.startAngle,
      label: i % 5 ? null : v / 1000 + "k"
    };
  });
}

function rand() {
  return 10000*Math.random();
}
