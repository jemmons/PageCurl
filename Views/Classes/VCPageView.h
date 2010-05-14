/* 
 If you find this code useful, please consider downloading a copy of the app that spawned it ( http://itunes.com/apps/VERVM ) and leaving a review.
 
 My thanks,
 -Joshua Emmons
 @jemmons
 
 */


#import "constants.h"
#define FLIP_DURATION 0.5f

@class VCClipLayer, VCFlipLayer, VCPageLayer, VCFlipShadowLayer;
@interface VCPageView : UIView <UIGestureRecognizerDelegate> {
	CGFloat portraitMultiplierTable[PORTRAIT_WIDTH];
	CGFloat landscapeMultiplierTable[LANDSCAPE_WIDTH];
	CGFloat portraitBackMultiplierTable[PORTRAIT_WIDTH];
	VCClipLayer *thisPage;
	VCFlipLayer *flipPage;
	VCPageLayer *nextPage;
	VCPageLayer *lastPage;
	CALayer *spineLayer;
	VCFlipShadowLayer *flipShadow;

  BOOL isAnimating;
	BOOL isATap;
}
@property(nonatomic,retain) VCClipLayer *thisPage;
@property(nonatomic,retain) CALayer *nextPage;
@property(nonatomic,retain) CALayer *lastPage;
@property(nonatomic,retain) VCFlipLayer *flipPage;
@property(nonatomic,retain) CALayer *spineLayer;
@property(nonatomic,retain) VCFlipShadowLayer *flipShadow;

-(void)layoutLayers;
-(void)setNextImageName:(NSString *)anImageName;
-(void)setThisImageName:(NSString *)anImageName;
-(void)setFlipImageName:(NSString *)anImageName;
-(void)setLastImageName:(NSString *)anImageName;
-(void)doFlipForward:(UIGestureRecognizer *)aGestureRecognizer forOrientation:(UIInterfaceOrientation)anOrientation;
-(void)doFlipBack:(UIGestureRecognizer *)aGestureRecognizer forOrientation:(UIInterfaceOrientation)anOrientation;

@end
