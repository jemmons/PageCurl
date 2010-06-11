/* 
 This code is licensed under a Simplified BSD License. See LICENSE for details.
 If you find this code useful, please consider downloading a copy of the app that spawned it ( http://itunes.com/apps/VERVM ) and leaving a review.
 
 My thanks,
 -Joshua Emmons
 @jemmons
 
 */


#import "VCFlipShadowLayer.h"
#import <QuartzCore/CATransaction.h>
@interface VCFlipShadowLayer ()
-(void)setCurlAnimationPosition:(CGFloat)betweenZeroAndOne portrait:(BOOL)isPortrait;
@end
@implementation VCFlipShadowLayer

-(id)init{
	if(self=[super init]){
		[self setAnchorPoint:CGPointMake(1.0f, 1.0f)];
    UIImage *flipped = [UIImage imageNamed:@"flipshadow.png"];
    [self setContents:(id)[flipped CGImage]];
		
		NSInteger portraitPageWidth = PORTRAIT_HEIGHT * PAGE_RATIO;
		NSInteger landscapePageWidth = LANDSCAPE_HEIGHT * PAGE_RATIO;
		NSInteger pPad = PORTRAIT_WIDTH - portraitPageWidth;
		NSInteger lPad = LANDSCAPE_WIDTH - landscapePageWidth;
		for(int c=0; c<ANIMATION_MULTIPLIER; c++){
			CGFloat multiplier = c/(CGFloat)ANIMATION_MULTIPLIER;
			CGFloat inverseMultiplier = 1.0f - multiplier;

      if(c<180){
        CGFloat end = (1.0f - (180/(CGFloat)ANIMATION_MULTIPLIER)) * FLIP_RADIANS;
        CGFloat tmp = (c)/180.0f;
        transformTable[c] = CGAffineTransformMakeRotation(end*tmp);
      }else{
        transformTable[c] = CGAffineTransformMakeRotation(FLIP_RADIANS * inverseMultiplier);
      }
			
      portraitPositionTable[c] = CGPointMake((portraitPageWidth * inverseMultiplier)+pPad, PORTRAIT_HEIGHT);
			landscapePositionTable[c] = CGPointMake((landscapePageWidth * inverseMultiplier)+lPad, LANDSCAPE_HEIGHT);
			portraitBoundsTable[c] = CGRectMake(0.0f, 0.0f, (SHADOW_WIDTH*multiplier), PORTRAIT_HEIGHT);
			landscapeBoundsTable[c] = CGRectMake(0.0f, 0.0f, (SHADOW_WIDTH*multiplier), LANDSCAPE_HEIGHT);
		}
	}
	return self;
}


-(void)dealloc {
	[super dealloc];
}


-(void)setPortraitCurlAnimationPosition:(CGFloat)betweenZeroAndOne{
	[self setCurlAnimationPosition:betweenZeroAndOne portrait:YES];
}


-(void)setLandscapeCurlAnimationPosition:(CGFloat)betweenZeroAndOne{
	[self setCurlAnimationPosition:betweenZeroAndOne portrait:NO];	
}


#pragma mark -
#pragma mark PRIVATE
-(void)setCurlAnimationPosition:(CGFloat)betweenZeroAndOne portrait:(BOOL)isPortrait{
	NSInteger animationStage = betweenZeroAndOne * ANIMATION_MULTIPLIER;  
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	if(isPortrait){
		[self setPosition: portraitPositionTable[animationStage]];
		[self setBounds: portraitBoundsTable[animationStage]];
	}else{
		[self setPosition: landscapePositionTable[animationStage]];
		[self setBounds: landscapeBoundsTable[animationStage]];		
	}
	[self setAffineTransform: transformTable[animationStage]];	
	[CATransaction commit];	
}
@end
