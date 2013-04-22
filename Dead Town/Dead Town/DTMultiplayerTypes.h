//
//  DTMultiplayerTypes.h
//  Dead Town
//
//  Created by David Canavan on 19/04/2013.
//
//

// Multiplayer data enums
typedef enum
{
    MessageTypePlayerMoved = 0, // He's made a move
    MessageTypePlayerKilled, // He's been killed
    MessageTypePlayerQuit // He quit! That jerk face!
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

