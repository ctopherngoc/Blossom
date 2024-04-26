# Blossom

This is a personal project to create a Maplestory-like 2D side scrolling mmorpg game using the Godot 3.5 game engine. It is broken up into a game server, authentication server, gateway server and client executable.
The current release (v2.0.0) allows dedicated server hosting of the server, the authentication server and gateway server, (it was designed to run on Docker containers). It is possible to open up multiple
client executables to replicate multiple users logging into the server given the user has access to the login information. Currently there is not a registration page for the game. The server has two working map that populates monsters and players. You are able to navigate around the maps. 
Basic combat system and experience/character progression works. The death/revive animation currently does not work (have not converted to server authoratative death) but players can lose all their hp (can even go negative). 
Health recovery is only possible passivly by standing in a possition without moving. Possible rubber banding could occur if server desync happens. This could happen due to hardware reasons in addition to Godot 3.5 does not have true determinalistic locomotion.

### Prerequisites

Install Godot 3.5 on the running machine

### Installing/Executing
Current release (v2.0.0) is server authoritative model with server reconciliation and client prediction has been implemented. Although it is implemented, it is not true server authorative because Godot kinematics are not fully determinalistic.<br />
<br />
Local Install: <br />
Download the current release (v2.0.0) .zip from the release section. Unzip the executable.<br />
<br />
Run the Server executable.<br />
<br />
Run the Authentication executable.<br />
<br />
Run the Gateway executable.<br />
<br />
Run the Client executable.<br />
<br />
The client, test login credentials will be automatically populated. Click on the login button. <br />
Once server authenticates user info and client is connected to server, select the test character and click on select character. Character will spawn in and populated into the server<br />

## Controls

CRTL: Attack<br />
ALT:     Jump<br />
Up:      Climb up/ Use Portal<br />
Down:    Climb Down<br />
Left:    Move Left<br />
Right    Move Right<br />

## Built With

* [Godot 3.5](https://godotengine.org/article/godot-3-5-cant-stop-wont-stop/) - Game Engine
* [Firebase Authentication](https://firebase.google.com/products/auth) - Account Management
* [Firestore Database](https://firebase.google.com/products/storage) - Server Database

* **Christopher Nguyen** - *Initial work* - [ctopherngoc](https://github.com/ctopherngoc)

