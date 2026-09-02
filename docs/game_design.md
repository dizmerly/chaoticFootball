# Game Design


## Core Gameplay 

The gameplay loop is mostly fairly straightforward. The core idea is a simple pick up the ball
and shoot it into the net type of game. The game isn't designed to be inherently competitive, however
care is taken in order to balance abilities. Likewise, outside of designated party modes, randomized events
are going to be limited if not fully ommitted, to promote a fair experience for each player. Ideally, 
given two players who always play the exact same, the match should always end in the same way, i.e. 
the gameplay loop is ideally deterministic.

### Player Movement
Movement is based on raw inputs. Players do not experience any inertia while moving. Likewise, the player moves horizontally in the air the same way that they move horizontally whilst on a floor. This choice was made in order to encourage a more consistent feeling of movement. There are also current and future movement enhancements and tricks. Currently the player is able to double jump, and jumps feature jump cuts. In other words, the height of the jump is dependent on the length of time the player holds down their respective jump button. Jumps max out at a certain height.
There is currently a trick, that initially was a bug but left in intentionally, when shooting the ball at one's feet at an acute angle, the player can perform a "ball jump", essentially something similar to a rocket jump, where the player shoots up into the air at a high velocity. This happens because after the player shoots the ball, collisions are briefly enabled between players and the ball. 

### Controller connections
The game is very flexible in how it manages connected controllers. Each contorller connected is given an id in the game, and whenever a game is loaded a player is assigned a controller id, and that contrller controls that player node. The same thing happens with selected characters, each controller id  is mapped to a spritesheet. 

Controller id's are served on a first come first serve basis. Whenever a controller disconnects, it's id becomes vacant until the same controller or another controller reconnects to that id. Currently there is no menu to map the id's to controller in the UI. 
