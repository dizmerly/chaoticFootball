# TODO

BUG Ball sprite is going into the other sprites really weirldy
When ball is bouncing, the ball sprite will basically go inside the sprite
below, even when the sprite below should be colliding, and 
the ball's collision shape is even large than its sprite, so 
no idea why this happened. 

BUG 
When jumping and throwing the ball, if you are reasonably close enough to the goalpost
you can throw the ball through the collision shape
FIXED - the problem was that the physics tick speed was too slow 
(changed to 120) and the physics collision solver is continous now which better
calculates physics collisions. 

BUG 



TODO: 
Goal scoring animations, custom scenes
