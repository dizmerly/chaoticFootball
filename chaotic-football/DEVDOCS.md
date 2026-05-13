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


TODO:
my idea is to basically take the averages of the positions
of the characters from the ball, and the center point of the 
viewport will be some sort of offset of that. as in like if 
2 players are equidistant from the ball, the the center is will
just land at balls position since the distance	
