# simple bar chart example
# http://mbostock.github.com/d3/tutorial/bar-1.html

# load some data
data = [4, 8, 15, 16, 23, 42]

# create chart container
chart = d3.select("#canvas")
  .append("div")
  .attr("class", "chart")

# style bars
style
  '.chart div':
    'font': '10px sans-serif'
    'background-color': 'steelblue'
    'text-align': 'right'
    'padding': '3px'
    'margin': '1px'
    'color': 'white'

# draw bars
chart.selectAll("div")
  .data(data)
  .enter().append("div")
  .style("width", (d) -> d * 10 + "px" )
  .text( (d) -> return d )
