
# Task List




### Functionality
[x] Basic Gameplay Loop

[x] Ability for the character

[x] Ball physics and scoring goals

[x] Basic Teleport ability

[x] Local Multiplayer

[ ] Online Multiplayer

### UI
[X] Scoreboard

[X] Local multiplayer controller popup for player to join

[X] Working Main Menu

[ ] Character selection

[ ] Map selection

[X] Settings menu with saved settings file

[ ] Goal banner accross after a goal.

### Miscellaneous 
[ ] More character designs

### Fun extras
[ ] Level Editor

[ ] Different abilities, with ability to select them



# TODO's and Bugs

May/June 2026

BUG Ball sprite is going into the other sprites really weirldy
When ball is bouncing, the ball sprite will basically go inside the sprite
below, even when the sprite below should be colliding, and 
the ball's collision shape is even large than its sprite, so 
no idea why this happened. 

BUG When jumping and throwing the ball, if you are reasonably close enough to the goalpost
you can throw the ball through the collision shape
FIXED - the problem was that the physics tick speed was too slow 
(changed to 120) and the physics collision solver is continuous now which better
calculates physics collisions. 



TODO: 
Goal scoring animations, custom scenes


TODO:
my idea is to basically take the averages of the positions
of the characters from the ball, and the center point of the 
viewport will be some sort of offset of that. as in like if 
2 players are equidistant from the ball, the the center is will
just land at balls position since the distance	

TODO:
Add a menu screen, along with an active scoreboard. 

TODO: 
Try to make the rocket jump style move with the ball an actualy feature,
it seems like a super cool and fun move that rewards game exploration,
and it opens up the cieling for skillful movement


TODO:
Whenever there is no ball in possession, the action button should 
emit a force field to throw the ball out of the other players possession
If the ball is in the players possession, then the player upon action 
button just shoots the ball. 

Bug:
campfire sometimes gets you stuck into the floor. 



### Timeline

#### 7/26/26
Finished connecting the scoreboard, values are now correctly updating whenever 
a goal is scored. Began working on controller confirmation for joining the game. 

#### 7/28/26
Pressing A to join implemented, fixed controllers not being recognized when loading from menu.
Added ball resetting mechanic whenever a goal is scored.

#### 8/7/26
Added a settings menu and popup menu. Menus save user configs. 


#### 8/12/26
Working on character selection screen. The general idea for how its supposed to work
is whenever the player selects the start game menu, they are loaded into the character selection
screen, each controller can select their player skin, and that skin is passed into the player
load skin function, in the game manager script. Later on, the character selection screen
should be expanded into a horizontal grid system with probably up to 8 players total between
red and blue teams. 
