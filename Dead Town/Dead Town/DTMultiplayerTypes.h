//
//  DTMultiplayerTypes.h
//  Dead Town
//
//  Created by David Canavan on 19/04/2013.
//
//

// Multiplayer data enums and structs
typedef enum
{
    MessageTypePlayerMoved = 0, // He's made a move
    MessageTypePlayerKilled, // He's been killed
    MessageTypePlayerQuit, // He quit! That jerk face!
    MessageTypePlayerFired, // He's taken a shot, started or stopped shooting
    MessageTypeWeaponChanged // He's gotten a new gun
} DTMessageType;

typedef struct
{
    DTMessageType type;
} DTMessage;

typedef struct
{
    DTMessage message; // Always start with a message so we can read this first from the void*
    float x, y;
    float vx, vy;
} DTMessagePlayerMoved;

typedef enum
{
    FireTypeShot, // Discrete shot
    FireTypeHoldStart, // Start of a continuous fire
    FireTypeHoldEnd // End of a continuous fire
} DTFireType;






