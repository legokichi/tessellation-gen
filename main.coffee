WIDTH = 800
HEIGHT = 800
POINTS = 3

class Point then constructor: (@x, @y)->
distance = (a, b)-> Math.sqrt(Math.pow(b.x - a.x, 2) + Math.pow(b.y - a.y, 2))
gen = (size)-> Math.random()*size|0
findBottomRight = (a, P)-> P.filter (p)-> p.x > a.x and p.y > a.y
findTopRight    = (a, P)-> P.filter (p)-> p.x > a.x and p.y < a.y

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
  tuples = _P.map (q, i)-> [p, distance(p, q)]
  tuples.sort ([pA, distA], [pB, distB])-> distA > distB
  if tuples.length > 0
    near = _P.splice(_P.indexOf(tuples[0][0]), 1)[0]
  else
    near = new Point(Infinity, Infinity)
  o.push({p, near, _P})
  o
), [])

# ある点 p の最近傍点 near から見た _P の右上最近傍点 near2 を探索
P = P.reduce(((o, {p, near, _P}, i)->
  __P = findTopRight(near, _P)
  tuples = __P.map (q, i)-> [near, distance(near, q)]
  tuples.sort ([pA, distA], [pB, distB])-> distA > distB
  if tuples.length > 0
    near2 = tuples[0][0]
  else
    near2 = new Point(WIDTH, HEIGHT)
  o.push({p, near, near2})
  o
), [])

console.log P
# 領域を算出
console.log bounds = P.map ({p, near, near2})->
  top: p.y
  left: p.x
  width: if near2.x > p.x then near.x else p.x
  height: if near.y > p.y then near.y else p.y

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
