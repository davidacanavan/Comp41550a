//
//  DTGuiTypes.h
//  Dead Town
//
//  Created by David Canavan on 23/04/2013.
//
//

#define GOOEY_FONT_SIZE 22
#define GOOEY_FONT_NAME @"Marker Felt"

#define GOOEY_PADDING_LEFT 15
#define GOOEY_PADDING_RIGHT 15
#define GOOEY_PADDING_TOP 15
#define GOOEY_PADDING_BOTTOM 15

#define GOOEY_LIFE_NODE_WIDTH 160
#define GOOEY_LIFE_NODE_HEIGHT 20

typedef enum {DTDominantHandLeft, DTDominantHandRight} DTDominantHand;
typedef enum {DTControllerTypeJoystick, DTControllerTypeTilt} DTControllerType;

typedef enum
{
    DTLayoutCornerTopLeft, DTLayoutCornerTopRight,
    DTLayoutCornerBottomLeft, DTLayoutCornerBottomRight
} DTLayoutCorner;