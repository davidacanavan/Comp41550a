

#import <UIKit/UIKit.h>
#import "PolygonShape.h"
#import "PolygonView.h"

@interface ViewController : UIViewController

- (IBAction)decrease:(UIButton *)sender;
- (IBAction)increase:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *increaseButton;
@property (weak, nonatomic) IBOutlet UIButton *decreaseButton;
@property (weak, nonatomic) IBOutlet UILabel *numberOfSidesLabel;
@property (strong, nonatomic) IBOutlet PolygonShape *model;
@property (weak, nonatomic) IBOutlet PolygonView *polygonView;
@property (weak, nonatomic) IBOutlet UILabel *polygonTitle;
@property (nonatomic, readonly) int numberOfSides;

@end
