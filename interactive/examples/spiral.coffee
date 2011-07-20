# requires raphael

width = $('#canvas').width()
height = $('#canvas').height()
paper = Raphael("canvas", width, height)

posx = (i) -> width/2 + 9*i*Math.sin(Math.PI/12*i)
posy = (i) -> height/2 + 9*i*Math.cos(Math.PI/12*i)
size = (i) -> i/2 + 1

circles = paper.set()
for i in [1..80]
  circles.push paper.circle(posx(i),posy(i),size(i))
  .attr
    fill: color = Raphael.getColor()
    opacity: 0.9
    "stroke": "#333"
    "stroke-width": 1
    "stroke-opacity": 0
