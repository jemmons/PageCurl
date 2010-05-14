/* 
 If you find this code useful, please consider downloading a copy of the app that spawned it ( http://itunes.com/apps/VERVM ) and leaving a review.
 
 My thanks,
 -Joshua Emmons
 @jemmons
 
 */


#import "VCFlipLayer.h"
#import <QuartzCore/CATransaction.h>
@interface VCFlipLayer ()
-(void)setCurlAnimationPosition:(CGFloat)betweenZeroAndOne portrait:(BOOL)isPortrait;
@end
@implementation VCFlipLayer

-(id)init{
	if(self=[super init]){
		[self setMasksToBounds:YES];
		[self setAnchorPoint:CGPointMake(1.0f, 1.0f)];

		
		NSInteger portraitPageWidth = PORTRAIT_HEIGHT * PAGE_RATIO;
		NSInteger landscapePageWidth = LANDSCAPE_HEIGHT * PAGE_RATIO;
		NSInteger pPad = PORTRAIT_WIDTH - portraitPageWidth;
		NSInteger lPad = LANDSCAPE_WIDTH - landscapePageWidth;
		for(int c=0; c<ANIMATION_MULTIPLIER; c++){
			CGFloat multiplier = c/(CGFloat)ANIMATION_MULTIPLIER;
			CGFloat inverseMultiplier = 1.0f - multiplier;

			contentCenterTable[c] = CGRectMake(multiplier, 0.0f, inverseMultiplier, 0.0f);

      if(c<180){
        CGFloat end = (1.0f - (180/(CGFloat)ANIMATION_MULTIPLIER)) * FLIP_RADIANS;
        CGFloat tmp = (c)/180.0f;
        transformTable[c] = CGAffineTransformMakeRotation(end*tmp);
      }else{
        transformTable[c] = CGAffineTransformMakeRotation(FLIP_RADIANS * inverseMultiplier);
      }
			
      portraitPositionTable[c] = CGPointMake((portraitPageWidth * inverseMultiplier)+pPad, PORTRAIT_HEIGHT);
			landscapePositionTable[c] = CGPointMake((landscapePageWidth * inverseMultiplier)+lPad, LANDSCAPE_HEIGHT);
			portraitBoundsTable[c] = CGRectMake(0.0f, 0.0f, ((portraitPageWidth)*multiplier), PORTRAIT_HEIGHT);
			landscapeBoundsTable[c] = CGRectMake(0.0f, 0.0f, (landscapePageWidth*multiplier), LANDSCAPE_HEIGHT);
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
	CGFloat fraction = betweenZeroAndOne;
	if(fraction > 0.999f){
		fraction = 0.9999f;
	}
	NSInteger animationStage = fraction * ANIMATION_MULTIPLIER;  
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	if(isPortrait){
		[self setPosition: portraitPositionTable[animationStage]];
		[self setBounds: portraitBoundsTable[animationStage]];
	}else{
		[self setPosition: landscapePositionTable[animationStage]];
		[self setBounds: landscapeBoundsTable[animationStage]];		
	}
	
	//This is a strange hack to simulate the clipping of the flipped page. I couldn't find a way to actually clip the layer in an animated way that didn't decimate performance, so I'm simulating clipping by animating the contentsCenter insteade. Finding a way to do actual clipping would make this all a lot more sane.
	[self setContentsCenter: contentCenterTable[animationStage]];
	[self setAffineTransform: transformTable[animationStage]];	
	[CATransaction commit];	
}
@end
