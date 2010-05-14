/* 
 If you find this code useful, please consider downloading a copy of the app that spawned it ( http://itunes.com/apps/VERVM ) and leaving a review.
 
 My thanks,
 -Joshua Emmons
 @jemmons
 
 */


#import "VCClipLayer.h"
#import <QuartzCore/QuartzCore.h>
@implementation VCClipLayer

-(id)init{
	if(self = [super init]){
		[self setAnchorPoint:CGPointMake(0.0f, 0.0f)];
		[self setMasksToBounds:YES];
		
		CGFloat portraitPageWidth = PORTRAIT_HEIGHT * PAGE_RATIO;
		CGFloat landscapePageWidth = LANDSCAPE_HEIGHT * PAGE_RATIO;
		for(int c=0; c<ANIMATION_MULTIPLIER; c++){
			CGFloat multiplier = c/(CGFloat)ANIMATION_MULTIPLIER;
			CGFloat inverseMultiplier = 1.0f - multiplier;

			portraitPageBoundsTable[c] = CGRectMake(0.0f, 0.0f, portraitPageWidth * inverseMultiplier, PORTRAIT_HEIGHT);
			landscapePageBoundsTable[c] = CGRectMake(0.0f, 0.0f, landscapePageWidth * inverseMultiplier, LANDSCAPE_HEIGHT);
		}
	}
	return self;
}


-(void)setPortraitCurlAnimationPosition:(CGFloat)betweenZeroAndOne{
	NSInteger animationStage = betweenZeroAndOne * ANIMATION_MULTIPLIER;
	
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	
	[self setBounds:portraitPageBoundsTable[animationStage]];
	
	[CATransaction commit];	
}


-(void)setLandscapeCurlAnimationPosition:(CGFloat)betweenZeroAndOne{
	CGFloat fraction = betweenZeroAndOne;
	if(fraction > 0.999f){
		fraction = 0.999f;
	}
	
	NSInteger animationStage = fraction * ANIMATION_MULTIPLIER;
	
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	
	[self setBounds:landscapePageBoundsTable[animationStage]];
	
	[CATransaction commit];
	
}


#pragma mark -
#pragma mark DRAWING
//-(void)drawInContext:(CGContextRef)c{
//	CGRect bounds = [self bounds];
//
//	NSInteger animationStage = [[self valueForKey:@"curlAnimationPosition"] floatValue] * ANIMATION_MULTIPLIER;
//	NSInteger curlPosition = 0;
//	if(IS_PORTRAIT){
//		curlPosition = portraitCurlPositionTable[animationStage];
//	}else{
//		curlPosition = landscapeCurlPositionTable[animationStage];
//	}	
//	
//	if(curlPosition > 0){
//		CGFloat deviation = deviationTable[curlPosition];
//		CGContextMoveToPoint(c, 0.0f, bounds.size.height);
//		CGContextAddLineToPoint(c, 0.0f, 0.0f);
//		CGContextAddLineToPoint(c, curlPosition + deviation, 0.0f);
//		CGContextAddLineToPoint(c, curlPosition, bounds.size.height);
//		CGContextClosePath(c);
//		CGContextClip(c);
//	}
//
//	UIGraphicsPushContext(c);
//	[[self valueForKey:@"image"] drawInRect:bounds];
//	UIGraphicsPopContext();
//}

@end
