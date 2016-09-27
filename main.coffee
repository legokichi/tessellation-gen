WIDTH = 100
HEIGHT = 100
POINTS = 10

class Point then constructor: (@x, @y)->
distance = (a, b)-> Math.sqrt(Math.pow(b.x - a.x, 2) + Math.pow(b.y - a.y, 2))
gen = (size)-> Math.random()*size|0
findBottomRight = (a, P)-> P.filter (p)-> p.x > a.x and p.y > a.y

P = (new Point(gen(WIDTH), gen(HEIGHT)) for i in [1...POINTS])
P.sort((a, b)=> a.y > b.y)
_P = P.reduce(((o, a, i)->
  p = P[i]
  left = findBottomRight(P[i], P.slice(i+1))
  near = Math.min.apply Math, left.map (p)-> distance(a, p)
  o.push({p, left, near})
  o
), [])
_P.map ({p, left, near})->
  console.log {p, left, near}
