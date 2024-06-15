(import-macros {: incf} :mac.math)
(local Object (require :lib.classic))
(local BOX (Object:extend))

(fn BOX.box [!] (values
  (* !.absw (- 1 !.w) !.x) (* !.absh (- 1 !.h) !.y)
  (+ (* !.absw (- 1 !.w) !.x) (* !.absw !.w))
  (+ (* !.absh (- 1 !.h) !.y) (* !.absh !.h))))

(fn BOX.in? [! x y] (let [(left top right bot) (!:box)]
  (and (> x left) (< x right) (> y top) (< y bot))))

(fn BOX.refresh [!] (when !.parent (let [(x y _ _) (!:box)]
  (!.t:setTransformation x y 0 !.w !.h))))

(fn BOX.new [! p x y w h]
  (let [(ww wh)   (love.window.getMode)
        [x y]     (if (and x y) [x y] [0 0])
        [w h]     (if (and w h) [w h] [ww wh])
        [pw ph]   (if p [p.absw p.absh] [w h])]
    (set [!.x !.y !.w !.h]         [x y w h])
    (set [!.ow !.oh !.absw !.absh] [w h pw ph])
    (set [!.t !.parent] [(love.math.newTransform) p]))
  (!:refresh))

(fn BOX.draw [! l?] 
  (when (not l?) (love.graphics.push))
  (love.graphics.applyTransform !.t)
  (love.graphics.rectangle :fill 0 0 !.absw !.absh)
  (love.graphics.setColor 0 0 0 1)
  (when l? (love.graphics.rectangle :line 0 0 !.absw !.absh))
  (when (not l?) (love.graphics.pop)))

(fn BOX.repose [! idx idy]
  (when (< !.w 1) (incf !.x (/ (* idx !.w) (- 1 !.w) !.absw)))
  (when (< !.h 1) (incf !.y (/ (* idy !.h) (- 1 !.h) !.absh)))
  (!:refresh))

(fn BOX.reshape [! idx idy]
  (incf !.w (/ (* idx !.w) !.absw))
  (incf !.h (/ (* idy !.h) !.absh))
  (when (~= [!.w !.h] [1 1]) (set [!.ow !.oh] [!.w !.h]))
  (!:refresh))

(fn BOX.restore [!]
  (if (and (>= !.w 1) (>= !.h 1))
      (set [!.x !.y !.w !.h] [!.x !.y !.ow !.oh])
      (set [!.x !.y !.w !.h] [0 0 1 1]))
  (!:refresh))

(fn BOX.itp [! x y ...]
  (let [(ix iy) (!.t:inverseTransformPoint x y)]
    (values ix iy ...)))

(fn BOX.mousepressed [! x y ...] (!:itp x y ...))

(fn BOX.mousereleased [! x y ...] (!:itp x y ...))

(fn BOX.mousemoved [! x y dx dy ...]
  (!:itp x y (/ dx !.w) (/ dy !.h) ...))

BOX
