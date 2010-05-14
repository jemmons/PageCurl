/* 
 If you find this code useful, please consider downloading a copy of the app that spawned it ( http://itunes.com/apps/VERVM ) and leaving a review.
 
 My thanks,
 -Joshua Emmons
 @jemmons
 
 */


#import "VCPageLayer.h"
#import "constants.h"

@interface VCFlipLayer : VCPageLayer {
CGRect contentCenterTable[ANIMATION_MULTIPLIER];
CGAffineTransform transformTable[ANIMATION_MULTIPLIER];
CGPoint portraitPositionTable[ANIMATION_MULTIPLIER];
CGPoint landscapePositionTable[ANIMATION_MULTIPLIER];
CGRect portraitBoundsTable[ANIMATION_MULTIPLIER];
CGRect landscapeBoundsTable[ANIMATION_MULTIPLIER];
}

-(void)setPortraitCurlAnimationPosition:(CGFloat)betweenZeroAndOne;
-(void)setLandscapeCurlAnimationPosition:(CGFloat)betweenZeroAndOne;

@end
