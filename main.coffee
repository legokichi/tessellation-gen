console.clear()
WIDTH = 800
HEIGHT = 800
POINTS = 5

class Point then constructor: (@x, @y)->
distance = (a, b)-> Math.sqrt(Math.pow(b.x - a.x, 2) + Math.pow(b.y - a.y, 2))
gen = (size)-> Math.random()*size|0
findBottomRight = (a, P)-> P.filter (p)-> p.x > a.x and p.y > a.y
findTopRight    = (a, P)-> P.filter (p)-> p.x > a.x and p.y < a.y
findNear = (a, P)->
  tuple = P.reduce((([mindist, minp], p)->
    if mindist < distance(a, p)
    then [mindist, minp]
    else [distance(a, p), p]
  ), [Infinity, new Point(Infinity, Infinity)])
  tuple[1]
remove = (p, P)-> P.splice(P.indexOf(p), 1); return
do ->
  debugger
  tmp = distance({x:0,y:0}, {x:1,y:1})
  console.assert tmp is 1.4142135623730951, "distance"
  tmp = findBottomRight({x:0,y:0}, [{x:1,y:1},{x:-1,y:1},{x:-1,y:-1},{x:1,y:-1}])[0]
  console.assert tmp.x is 1 and tmp.y is 1, "fBR"
  tmp = findTopRight({x:0,y:0}, [{x:1,y:1},{x:-1,y:1},{x:-1,y:-1},{x:1,y:-1}])[0]
  console.assert tmp.x is 1 and tmp.y is -1, "fTR"
  tmp = findNear({x:0.1,y:0.1}, [{x:1,y:1},{x:-1,y:1},{x:-1,y:-1},{x:1,y:-1}])
  console.assert tmp.x is 1 and tmp.y is 1, "fN"
  a = [0, 1, 2]
  remove(a[1], a)
  console.assert a.length is 2 and a[0] is 0 and a[1] is 2, "remove"

# ランダムに点生成（望ましいのは一様分布
P = (new Point(gen(WIDTH), gen(HEIGHT)) for i in [0...POINTS])

# いったん上から順番にソート
P.sort (a, b)-> a.y > b.y

# ある点 p に対してその左下の点集合を生成
P = P.reduce(((o, p, i)->
  _P = findBottomRight(p, P)
  o.push({p, _P})
  o
), [])

#️ ある点 p に一番近い左下集合の点 near を選択しその _P から取り除く
P = P.reduce(((o, {p, _P}, i)->
  near = findNear(p, _P)
  remove(near, _P)
  o.push({p, near, _P})
  o
), [])

# ある点 p の最近傍点 near から見た _P の右上最近傍点 near2 を探索
P = P.reduce(((o, {p, near, _P}, i)->
  __P = findTopRight(near, _P)
  near2 = findNear(p, __P)
  remove(near, __P)
  o.push({p, near, near2})
  o
), [])

console.log P
# 領域を算出
console.log bounds = P.map ({p, near, near2})->
  top: p.y
  left: p.x
  width: near2.x - p.x
  height: near.y - p.y

bounds.forEach ({top, left, width, height})->
  div = document.createElement("div")
  div.style.display = "inline-block"
  div.style.position = "absolute"
  div.style.top = top + "px"
  div.style.left = left + "px"
  div.style.width = width + "px" if isFinite(width)
  div.style.height = height + "px" if isFinite(height)
  div.style.border = "1px solid black"
  document.body.appendChild(div)
  div = document.createElement("div")
  div.style.border = "1px solid red"
  div.style.position = "absolute"
  div.style.top = top + "px"
  div.style.left = left + "px"
  document.body.appendChild(div)
