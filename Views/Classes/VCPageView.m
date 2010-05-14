/* 
 If you find this code useful, please consider downloading a copy of the app that spawned it ( http://itunes.com/apps/VERVM ) and leaving a review.
 
 My thanks,
 -Joshua Emmons
 @jemmons
 
 */


#import "VCPageView.h"
#import "VCClipLayer.h"
#import "VCFlipLayer.h"
#import "VCFlipShadowLayer.h"
#import <QuartzCore/QuartzCore.h>

@interface VCPageView ()
-(void)populateTable:(CGFloat[])aTable withWidth:(NSInteger)screenWidth andHeight:(NSInteger)screenHeight;
-(void)animateOpen;
-(void)animationWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight closing:(BOOL)isClosing;
-(void)animateClose;
-(void)doTapForward:(UIGestureRecognizer *)aGestureRecognizer;
-(void)doTapBack:(UIGestureRecognizer *)aGestureRecognizer;
-(BOOL)isPortrait;
@end
@implementation VCPageView
@synthesize thisPage, flipPage, nextPage, lastPage, spineLayer, flipShadow;


-(void)awakeFromNib{
  //Initializers:
  isAnimating = NO;
  
	//Lookup Tables:
	[self populateTable:portraitMultiplierTable withWidth:PORTRAIT_WIDTH andHeight:PORTRAIT_HEIGHT];
	[self populateTable:landscapeMultiplierTable withWidth:LANDSCAPE_WIDTH andHeight:LANDSCAPE_HEIGHT];
	CGFloat width = [self bounds].size.height * PAGE_RATIO;
	for(int c=0; c<width; c++){
		portraitBackMultiplierTable[c] = 1.0f - (c/width);
	}		
	
	//Sublayers:
	thisPage = [[VCClipLayer alloc] init];
	flipPage =[[VCFlipLayer alloc] init];
	nextPage = [[VCPageLayer alloc] init];
  
	spineLayer = [[CALayer alloc]init];
	[spineLayer setAnchorPoint:CGPointMake(0.5f, 0.0f)];
	UIImage *spine = [UIImage imageNamed:@"spine.png"];
	[spineLayer setContents:(id)[spine CGImage]];
  
	lastPage = [[VCPageLayer alloc] init];
	[lastPage setAnchorPoint:CGPointMake(1.0f, 1.0f)];
  
  flipShadow = [[VCFlipShadowLayer alloc]init];

	[[self layer] addSublayer:nextPage];
	[[self layer] addSublayer:lastPage];
	[[self layer] addSublayer:thisPage];
	[[self layer] addSublayer:spineLayer];
	[[self layer] addSublayer:flipPage];
  [[self layer] addSublayer:flipShadow];
	
	[self layoutLayers];
}


-(void)dealloc {
	[thisPage release];thisPage=nil;
	[flipPage release];flipPage=nil;
	[nextPage release];nextPage=nil;
	[lastPage release];lastPage=nil;
  [flipShadow release];flipShadow=nil;
  [spineLayer release];spineLayer=nil;
	[super dealloc];
}


-(void)layoutLayers{
	//This should be in -layoutSubviews, but that gets called like mad during animation because of automatic calls to CALayer -layoutIfNeeded.
	CGSize size = [self frame].size; 
	CGFloat pageHeight = size.height;
	CGFloat pageWidth = pageHeight * PAGE_RATIO;
	CGFloat pad = size.width - pageWidth;
	CGRect frame = CGRectMake(pad, 0.0f, pageWidth, pageHeight);
	[nextPage setFrame:frame];
	[thisPage setFrame:frame];
	[lastPage setBounds:CGRectMake(0.0f, 0.0f, pageWidth, pageHeight)];
	[lastPage setPosition:CGPointMake(pad, pageHeight)];
  [flipPage setFrame:CGRectMake(size.width, 0.0f, 0.0f, size.height)];
  [flipPage setHidden:NO];
  [flipShadow setFrame:CGRectMake(size.width, 0.0f, 0.0f, size.height)];
  [flipShadow setHidden:NO];
	
	[spineLayer setPosition:CGPointMake(pad, 0.0f)];
	[spineLayer setBounds:CGRectMake(0.0f, 0.0f, 128.0f, size.height)];
}


#pragma mark -
#pragma mark DRAWING
-(void)setNextImageName:(NSString *)anImageName{
	[nextPage setImageName:anImageName];
}


-(void)setThisImageName:(NSString *)anImageName{
	[thisPage setImageName:anImageName];
}


-(void)setFlipImageName:(NSString *)anImageName{
	[flipPage setImageName:anImageName];
}


-(void)setLastImageName:(NSString *)anImageName{
	[lastPage setImageName:anImageName];
}


#pragma mark -
#pragma mark TOUCHES
-(void)doFlipForward:(UIGestureRecognizer *)aGestureRecognizer forOrientation:(UIInterfaceOrientation)anOrientation{
	if(isAnimating)
		return;
	
	switch([aGestureRecognizer state]){
		case UIGestureRecognizerStateBegan:
			[CATransaction begin];
			[CATransaction setDisableActions:YES];
			[flipPage setHidden:NO];
      [flipShadow setHidden:NO];
			[CATransaction commit];			
			break;
			
		case UIGestureRecognizerStateChanged:
		{
			CGFloat multiplier = 0.0f;
			if(UIInterfaceOrientationIsPortrait(anOrientation)){
				multiplier = portraitMultiplierTable[(NSInteger)[aGestureRecognizer locationInView:self].x];
				[thisPage setPortraitCurlAnimationPosition:multiplier];
				[flipPage setPortraitCurlAnimationPosition:multiplier];
        [flipShadow setPortraitCurlAnimationPosition:multiplier];
			}else{
				multiplier = landscapeMultiplierTable[(NSInteger)[aGestureRecognizer locationInView:self].x];
				[thisPage setLandscapeCurlAnimationPosition:multiplier];
				[flipPage setLandscapeCurlAnimationPosition:multiplier];
        [flipShadow setLandscapeCurlAnimationPosition:multiplier];
			}
		}
			break;
			
		case UIGestureRecognizerStateEnded:
		{
			CGFloat transX = [(UIPanGestureRecognizer *)aGestureRecognizer translationInView:self].x;
			
			CGFloat width = [self bounds].size.height * PAGE_RATIO;
			if(width + transX < width/2){
				[self animateOpen];
			}else{
				[self animateClose];
			}
		}			
			break;
	}
}


-(void)doFlipBack:(UIGestureRecognizer *)aGestureRecognizer forOrientation:(UIInterfaceOrientation)anOrientation{
	if(isAnimating)
		return;
	
	switch([aGestureRecognizer state]){
		case UIGestureRecognizerStateBegan:
			[CATransaction begin];
			[CATransaction setDisableActions:YES];
			[[UIApplication sharedApplication] sendAction:@selector(pageFlippedBack:) to:nil from:self forEvent:nil];
			[thisPage setBounds:CGRectMake(0.0f, 0.0f, 0.0f, [self bounds].size.height)];
			[flipPage setHidden:NO];
      [flipShadow setHidden:NO];
			[CATransaction commit];			
			break;
			
		case UIGestureRecognizerStateChanged:
		{
			CGFloat multiplier = 0.0f;
			if(UIInterfaceOrientationIsPortrait(anOrientation)){
				multiplier = portraitBackMultiplierTable[(NSInteger)[aGestureRecognizer locationInView:self].x];
				[thisPage setPortraitCurlAnimationPosition:multiplier];
				[flipPage setPortraitCurlAnimationPosition:multiplier];
        [flipShadow setPortraitCurlAnimationPosition:multiplier];
			}else{
				multiplier = landscapeMultiplierTable[(NSInteger)[aGestureRecognizer locationInView:self].x];
				[thisPage setLandscapeCurlAnimationPosition:multiplier];
				[flipPage setLandscapeCurlAnimationPosition:multiplier];
        [flipShadow setLandscapeCurlAnimationPosition:multiplier];
			}
		}
			break;
			
		case UIGestureRecognizerStateEnded:
		{
			CGFloat transX = [(UIPanGestureRecognizer *)aGestureRecognizer translationInView:self].x;
			
			CGFloat width = [self bounds].size.width;
			if(transX > width/2){
				[self animateClose];
			}else{
				[self animateOpen];
			}
		}			
			break;
	}
}


-(void)doTapForward:(UIGestureRecognizer *)aGestureRecognizer{
	if(isAnimating)
		return;
	
  [CATransaction begin];
  [CATransaction setDisableActions:YES];
  [flipPage setHidden:NO];
  [flipShadow setHidden:NO];
  [CATransaction commit];	
	
	//!!!: ugly hack!!!!
	isATap = YES;
  [self animateOpen];
}


-(void)doTapBack:(UIGestureRecognizer *)aGestureRecognizer{
	if(isAnimating)
		return;
	
  CGSize size = [self bounds].size;
  CGFloat pageWidth = size.height *PAGE_RATIO;
  
  [CATransaction begin];
  [CATransaction setDisableActions:YES];
  [[UIApplication sharedApplication] sendAction:@selector(pageFlippedBack:) to:nil from:self forEvent:nil];
  [thisPage setBounds:CGRectMake(0.0f, 0.0f, 0.0f, [self bounds].size.height)];
  [flipPage setPosition:CGPointMake(size.width-pageWidth, size.height)];
  [flipShadow setPosition:CGPointMake(size.width-pageWidth, size.height)];
  [flipPage setBounds:CGRectMake(0.0f, 0.0f, pageWidth, size.height)];
  [flipShadow setBounds:CGRectMake(0.0f, 0.0f, SHADOW_WIDTH, size.height)];

  [flipPage setHidden:NO];
  [flipShadow setHidden:NO];
  [CATransaction commit];			

  [self animateClose];
}



#pragma mark -
#pragma mark DELEGATE
-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
	[thisPage removeAnimationForKey:@"bounds"];
	[flipPage removeAnimationForKey:@"bounds"];
	[flipPage removeAnimationForKey:@"position"];
	[flipShadow removeAnimationForKey:@"bounds"];
	[flipShadow removeAnimationForKey:@"position"];

	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	[thisPage setContentsCenter:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
	[flipPage setHidden:YES];
	[flipShadow setHidden:YES];
	[flipPage setContentsCenter:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];

	CGSize size = [self bounds].size;
	CGFloat pageWidth = size.height * PAGE_RATIO;
	[flipPage setFrame:CGRectMake(size.width, 0.0f, 0.0f, size.height)];
	[flipShadow setFrame:CGRectMake(size.width, 0.0f, 0.0f, size.height)];
	[thisPage setFrame:CGRectMake(size.width - pageWidth, 0.0f, pageWidth, size.height)];

	if( ! [[(CABasicAnimation *)theAnimation toValue] CGRectValue].size.width > 0){
		[[UIApplication sharedApplication] sendAction:@selector(pageFlipped:) to:nil from:self forEvent:nil];
	}

	[CATransaction commit];
  isAnimating=NO;
}


#pragma mark -
#pragma mark PRIVATE
	-(void)populateTable:(CGFloat[])aTable withWidth:(NSInteger)screenWidth andHeight:(NSInteger)screenHeight{
	NSInteger localPageWidth = screenHeight * PAGE_RATIO;
	NSInteger fullWidth = localPageWidth * 2;
	NSInteger nonScreenWidth = fullWidth - screenWidth;
	for(int c=0; c<screenWidth; c++){
		aTable[c] = (fullWidth-(nonScreenWidth+c))/(CGFloat)fullWidth;
	}		
}


-(void)animateOpen{
  isAnimating = YES;
	CGSize size = [self bounds].size;
	[self animationWithWidth:size.width andHeight:size.height closing:NO];
}


-(void)animateClose{
  isAnimating = YES;
	CGSize size = [self bounds].size;
	[self animationWithWidth:size.width andHeight:size.height closing:YES];
}


-(void)animationWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight closing:(BOOL)isClosing{
  CGFloat pageWidth = aHeight * PAGE_RATIO;
	CABasicAnimation *animation = nil;
	
	//This is done as a basic animation so we can attach a delegate.
	animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
	if(isClosing){
		[animation setToValue:[NSValue valueWithCGRect:CGRectMake(0.0f, 0.0f, pageWidth, aHeight)]];
	}else{
		[animation setToValue:[NSValue valueWithCGRect:CGRectMake(0.0f, 0.0f, 0, aHeight)]];		
	}
	[animation setDuration:FLIP_DURATION];
	[animation setFillMode:kCAFillModeForwards];
	[animation setRemovedOnCompletion:NO];
	[animation setDelegate:self];
	[thisPage addAnimation:animation forKey:@"bounds"];
	
	//We're doing these as Basic Animations because the timeing of implicite animations doesn't line up with the above.
	animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
	if(isClosing){
		[animation setToValue:[NSValue valueWithCGRect:CGRectMake(0.0f, 0.0f, 0, aHeight)]];
	}else{
		[animation setToValue:[NSValue valueWithCGRect:CGRectMake(0.0f, 0.0f, pageWidth, aHeight)]];
	}
	[animation setDuration:FLIP_DURATION];
	[animation setFillMode:kCAFillModeForwards];
	[animation setRemovedOnCompletion:NO];
	[flipPage addAnimation:animation forKey:@"bounds"];

	animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
	if(isClosing){
		[animation setToValue:[NSValue valueWithCGRect:CGRectMake(0.0f, 0.0f, 0, aHeight)]];
	}else{
		[animation setToValue:[NSValue valueWithCGRect:CGRectMake(0.0f, 0.0f, SHADOW_WIDTH, aHeight)]];
	}
	[animation setDuration:FLIP_DURATION];
	[animation setFillMode:kCAFillModeForwards];
	[animation setRemovedOnCompletion:NO];
	[flipShadow addAnimation:animation forKey:@"bounds"];
  
	animation = [CABasicAnimation animationWithKeyPath:@"position"];
	if(isClosing){
		[animation setToValue:[NSValue valueWithCGPoint:CGPointMake(aWidth, aHeight)]];
	}else{
		[animation setToValue:[NSValue valueWithCGPoint:CGPointMake(aWidth - pageWidth, aHeight)]];		
	}
	[animation setDuration:FLIP_DURATION];
	[animation setFillMode:kCAFillModeForwards];
	[animation setRemovedOnCompletion:NO];
	[flipPage addAnimation:animation forKey:@"position"];	

  animation = [CABasicAnimation animationWithKeyPath:@"position"];
	if(isClosing){
		[animation setToValue:[NSValue valueWithCGPoint:CGPointMake(aWidth, aHeight)]];
	}else{
		[animation setToValue:[NSValue valueWithCGPoint:CGPointMake(aWidth - pageWidth, aHeight)]];		
	}
	[animation setDuration:FLIP_DURATION];
	[animation setFillMode:kCAFillModeForwards];
	[animation setRemovedOnCompletion:NO];
  [flipShadow addAnimation:animation forKey:@"position"];
	
	//However, can't figure out how to wrap affine tranform without NSAffineTransform. But timing isn't as critical here anyway.
	[CATransaction begin];
	[CATransaction setAnimationDuration:FLIP_DURATION];
  [flipPage setAffineTransform:CGAffineTransformIdentity];
  [flipShadow setAffineTransform:CGAffineTransformIdentity];
	if( (! isClosing) && (! isATap) ){
		[flipPage setContentsCenter:CGRectMake(1, 0, 1, 0)];
	}
  isATap = NO;
	[CATransaction commit];
}

-(BOOL)isPortrait{
	return YES;
//	if([self bounds].size.height
}


@end
