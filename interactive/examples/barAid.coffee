# Set up
chart = d3.select("#canvas")
minTime = 1976
maxTime = 2009
t = minTime
$('#canvas').append("<h2>" + t + "</h2><h1>US Foreign Economic Aid</h1><p id='countryTotal'></div><div class='clearfix'></div>")

# Some Data Structures
window.countryList = []
ct = 0
window.yearlyTotals = []
for masterCountry of countryTotals
  countryList.push
    country: masterCountry
    colorClass: "c"+ct
    color: Raphael.getColor()
  yearlyTotals.push
    country: masterCountry
    years: {}
  ct++

makeData = (countries) ->
  for country, dates of countries
    for i in countryList
      if country is i.country
        i.cash = dates[t]
    for b in yearlyTotals
      if country is b.country
        for u,v of dates
          b.years[u] += v ? 0
  return countryList

getCountryClass = (country) ->
  for c,i in countryList
    if country is c.country
      return c.colorClass

# Init JSON and make each bar
d3.json "data/aid.json", (depts) ->
  for dept, countries of depts
    bar = chart.data(makeData(countries)).append("div").attr("class","bar")
    bar.append("label").text(dept)
    barInner = bar.append("div").attr("class","barInner")
    bar.append("p")
    bar.append("div").attr("class","clearfix")
    fillBar(countries, bar, barInner)
    updateBars countries, bar, barInner
    runHovers()

fillBar = (countries, bar, barInner) ->
  barVal = 0
  $("h2").text(t)
  for country, dates of countries
    val = dates[t]
    barVal += val
    if val isnt null
      section = barInner.append("div")
                      .attr("class","section")
      makeSection(val, section, country)
  barInner.attr("width", scaleData(barVal) + "px")
  bar.selectAll("p").text("$"+formatMoney(barVal))

# Make each block within each bar
makeSection = (val, section, country) ->
  newVal = scaleData(val)
  color = getCountryClass country
  section.style("width", newVal + "px")
         .attr("title", country + ": $" + formatMoney(val))
         .classed color, true

# Event Functions
updateBars = (countries, bar, barInner) ->
  $('body').bind 'updateBars', ->
    barInner.selectAll("div").remove()
    fillBar(countries, bar, barInner)
    runHovers()

# Helper Functions
scaleData = (val) ->
  if val*.000000099999 < 1
    newVal = 1
  else
    newVal = val*.000000099999

getOtherClass = (element, excludedClass) ->
  classes = element.attr("className").split(" ")
  for classA in classes
    if classA isnt excludedClass
      return classA

# Event Binding
$("h2").bind "click", ->
  if t < maxTime
    t += 1
  $('body').trigger('updateBars')

runHovers = ->
  colorClass = ""
  $('.section').bind "mouseenter", ->
    colorClass = getOtherClass $(this), "section"
    for c in countryList
      if colorClass is c.colorClass
        $('.'+colorClass).css({background:c.color})
        $('#countryTotal').text(c.country)
  .bind "mouseleave", ->
    $('.'+colorClass).css({background:'transparent'})
    $('#countryTotal').text('')

style
  '#canvas div':
    'font': '10px sans-serif'
  '#canvas .section':
    'float':'left'
    'border':'1px solid #ccc'
    'border-left':'0'
    'height':'23px'
    'cursor':'pointer'
  '#canvas .bar':
    'margin-bottom':'5px'
    'background':'#eee'
    'height':'24px'
  '.bar label':
    'float':'left'
    'padding':'0px 10px 0 0'
    'border-right':'1px solid #ccc'
    'text-align':'right'
    'width':'160px'
    'color':'#555'
    'height':'25px'
  '.bar .barInner':
    'float':'left'
  '.bar p':
    'float':'left'
    'padding-left':'5px'
    'line-height':'23px'
    'margin':'0'
  'h2':
    'font-family':'impact, ariel, helvetica, sans-serif'
    'font-size':'32px'
    'float':'left'
    'margin':'0'
    'color':'#ccc'
    'width':'160px'
    'text-align':'right'
    'padding-right':'10px'
    'cursor':'pointer'
  'h1':
    'float':'left'
    'text-transform':'uppercase'
    'line-height':'43px'
    'height':'36px'
    'margin':'0px'
  '#countryTotal':
    'float':'right'
    'line-height':'36px'
    'height':'36px'
    'text-align':'right'
    'padding-right':'20px'
    'margin':'0'
  '.clearfix':
    'clear':'both'
 
getNewAid = (d) ->
  newAid = {}
  makeDate = (dt) ->
    dt = "" + dt
    y = dt.substring(2, 6)
    return parseInt(y)

  for row in d
    for key, val of row
      newAid[row.program_name] or= {}
      newAid[row.program_name][row.country_name] or= {}
      if key.substring(0,2) is "FY"
        if key.substring(6,8).length isnt 2
          date = makeDate(key)
          newAid[row.program_name][row.country_name][date] = val

formatMoney = (val) ->
  val = val.toString()
  len = val.length
  num_commas = Math.ceil(len/3)- 1
  newVal = val.substr(-3, 3)
  if num_commas > 0
    for i in [1..num_commas]
      pos = -(1+i)*3
      newVal = val.substr(pos, 3) + "," + newVal
  return newVal
