## Core Gameplay 

The gameplay loop is mostly fairly straightforward. The core idea is a simple pick up the ball
and shoot it into the net type of game. The game isn't designed to be inherently competitive, however
care is taken in order to balance abilities. Likewise, outside of designated party modes, randomized events
are going to be limited if not fully ommitted, to promote a fair experience for each player. Ideally, 
given two players who always play the exact same, the match should always end in the same way, i.e. 
the gameplay loop is ideally deterministic.

The game is very flexible in how it manages connected controllers. Each contorller connected is given an id in the game, and whenever a game is loaded
a player is assigned a controller id, and that contrller controls that player node. The same thing happens with selected characters, each controller id
is mapped to a spritesheet.
