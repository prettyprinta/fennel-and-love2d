(local Enemy (require "src.rochambullet.classes.enemy"))
(local Scissors (Enemy:extend))
(tset Scissors :new (fn [self range x y]
   (Scissors.super.new self range x y)
   (set self.type "scissors")
   self))
(tset Scissors :draw (fn [self ox oy]
   (love.graphics.setColor 0 1 0)
   (Scissors.super.draw self ox oy)))
Scissors
