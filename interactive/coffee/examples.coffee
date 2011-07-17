# examples
window.examples =
  'force':
    intro: "A force-directed layout. Click and drag nodes"
    file: "examples/force.coffee"
    type: "coffee"
    requirements: ["../d3/d3.js", "../d3/d3.layout.js", "../d3/d3.geom.js"]
    help: "Usage: force [json file]"
  'graph':
    intro: "A force-directed layout. Click and drag nodes"
    file: "examples/graph.coffee"
    type: "coffee"
    requirements: ["../d3/d3.js", "../d3/d3.layout.js", "../d3/d3.geom.js"]
  'chord':
    intro: "A network visualization. Hover over arcs to see connections"
    file: "examples/chord.coffee"
    type: "coffee"
    requirements: ["../d3/d3.js", "../d3/d3.layout.js"]
  'splom':
    intro: "Mutliple scatterplots. Click and drag to select points"
    file: "examples/splom.coffee"
    type: "coffee"
    requirements: ["../d3/d3.js"]
  'stream':
    intro: "A streamgraph. Click update to toggle dataset"
    file: "examples/stream.coffee"
    type: "coffee"
    requirements: ["../d3/d3.js", "../d3/d3.layout.js"]
  'unemployment':
    intro: "Unemployment in the United States"
    file: "examples/unemployment.coffee"
    type: "coffee"
    requirements: ["../d3/d3.js", "../d3/d3.geo.js"]
  'bar':
    intro: "A basic bar chart"
    file: "examples/bar.coffee"
    type: "coffee"
    requirements: ["../d3/d3.js"]
  'spiral':
    intro: "Far out!"
    file: "examples/spiral.coffee"
    type: "coffee"
    requirements: ["js/raphael.js"]
  'aid':
    intro: "US Foreign Aid"
    file: "examples/aid.coffee"
    type: "coffee"
    requirements: ["../d3/d3.js", "../d3/d3.geo.js"]
  'barAid':
    intro: "US Foreign Aid"
    file: "examples/barAid.coffee"
    type: "coffee"
    requirements: ["../d3/d3.js", "data/aidList.js"]
###
  'brain':
    intro: "Neural network with Brain.js"
    file: "examples/brain.coffee"
    type: "coffee"
    requirements: ["js/brain.js"]
###

for ex of examples
  window[ex] = examples[ex]
  window[ex].name = ex
