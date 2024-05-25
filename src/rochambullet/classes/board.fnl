(import-macros {: incf : decf} :mac.math)
(local Object (require "lib.classic"))
(local Board (Object:extend))
(tset Board :new (fn [self tiles tilepx]
  (set self.tiles tiles)
  (set self.tilepx tilepx)
  (set self.px (* self.tiles self.tilepx))
  self))
(tset Board :fit (fn [self pos]
  (local x pos.x)
  (local y pos.y)
  (when (< (+ pos.x (/ self.px 2)) 0)
      (incf pos.x self.px))
  (when (> (+ pos.x (/ self.px 2)) self.px)
      (decf pos.x self.px))
  (when (< (+ pos.y (/ self.px 2)) 0)         
      (incf pos.y self.px))
  (when (> (+ pos.y (/ self.px 2)) self.px)  
      (decf pos.y self.px))
  (or (~= x pos.x) (~= y pos.y))))
(tset Board :draw (fn [self x y]
  (love.graphics.push)
  (love.graphics.translate (- x (/ self.px 2)) (- y (/ self.px 2)))
  (for [j 0 (- self.tiles 1)] (for [i 0 (- self.tiles 1)]
    (if (= (% (+ i j) 2) 0) 
        (love.graphics.setColor 0.5 0.25 0.125 1)
        (love.graphics.setColor 0.25 0.125 0 1))
    (love.graphics.rectangle "fill" (* j self.tilepx)  (* i self.tilepx)
                                    self.tilepx        self.tilepx)))
  (love.graphics.setColor 1 1 1 1)
  ;(love.graphics.rectangle "line" 0 0 self.px self.px)
  (love.graphics.pop)))
(tset Board :draw* (fn [self] ;; TODO inefficient, draw visible dupes only
  (self:draw (* self.px -1)  (* self.px -1))
  (self:draw (* self.px 0)   (* self.px -1))
  (self:draw (* self.px 1)   (* self.px -1))
  (self:draw (* self.px -1)  (* self.px 0))
  (self:draw (* self.px 0)   (* self.px 0))
  (self:draw (* self.px 1)   (* self.px 0))
  (self:draw (* self.px -1)  (* self.px 1))
  (self:draw (* self.px 0)   (* self.px 1))
  (self:draw (* self.px 1)   (* self.px 1))))
Board
