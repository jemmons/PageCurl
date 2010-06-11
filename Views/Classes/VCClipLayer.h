/* 
 This code is licensed under a Simplified BSD License. See LICENSE for details.
 If you find this code useful, please consider downloading a copy of the app that spawned it ( http://itunes.com/apps/VERVM ) and leaving a review.
 
 My thanks,
 -Joshua Emmons
 @jemmons
 
 */


#import "VCPageLayer.h"
#import "constants.h"

#define MAX_DEVIATION 72.0f

@interface VCClipLayer : VCPageLayer {
CGRect portraitPageBoundsTable[ANIMATION_MULTIPLIER];
CGRect landscapePageBoundsTable[ANIMATION_MULTIPLIER];
}

-(void)setPortraitCurlAnimationPosition:(CGFloat)betweenZeroAndOne;
-(void)setLandscapeCurlAnimationPosition:(CGFloat)betweenZeroAndOne;

@end
