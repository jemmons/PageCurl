/* 
 This code is licensed under a Simplified BSD License. See LICENSE for details.
 If you find this code useful, please consider downloading a copy of the app that spawned it ( http://itunes.com/apps/VERVM ) and leaving a review.
 
 My thanks,
 -Joshua Emmons
 @jemmons
 
 */


#import "VCBookViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "VCPageView.h"
#import "constants.h"

@interface VCBookViewController ()
-(NSUInteger)nextPageIndex;
-(NSUInteger)previousPageIndex;
-(NSUInteger)nextNextPageIndex;
-(NSUInteger)previousPreviousPageIndex;
-(void)selectNextPage;
-(void)selectPreviousPage;
-(void)selectPreviousPreviousPage;
-(NSString *)nameForSelectedPage;
-(NSString *)nameForNextPage;
-(NSString *)nameForPreviousPage;
-(NSString *)nameForNextNextPage;
@end
@implementation VCBookViewController
@synthesize pageView, rectoName, pageNames;
#pragma mark -

-(void)viewDidLoad{
	//Gesture Recognizers:
	flipFoward = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doFlipForward:)];
	[flipFoward setMaximumNumberOfTouches:1];
	[flipFoward setMinimumNumberOfTouches:1];
	[flipFoward setDelegate:self];
	[[self pageView] addGestureRecognizer:flipFoward];
	
	flipBack = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doFlipBack:)];
	[flipBack setMaximumNumberOfTouches:1];
	[flipBack setMinimumNumberOfTouches:1];
	[flipBack setDelegate:self];
	[[self pageView] addGestureRecognizer:flipBack];
	
  tapForward = [[UITapGestureRecognizer alloc] initWithTarget:pageView action:@selector(doTapForward:)];
	[tapForward setNumberOfTapsRequired:1];
	[tapForward setNumberOfTouchesRequired:1];
  [tapForward setDelegate:self];
	[[self pageView] addGestureRecognizer:tapForward];
	
  tapBack = [[UITapGestureRecognizer alloc] initWithTarget:pageView action:@selector(doTapBack:)];
	[tapBack setNumberOfTapsRequired:1];
	[tapBack setNumberOfTouchesRequired:1];
  [tapBack setDelegate:self];
	[[self pageView] addGestureRecognizer:tapBack];
	
	
	[self setRectoName:@"r.png"];
	[self setPageNames:[NSArray arrayWithObjects:@"1.png",@"2.png",@"3.png",@"4.png",@"5.png", nil]];
	selectedPageIndex = 0;
}


-(void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}


-(void)dealloc{
	[pageNames release];pageNames=nil;
	[rectoName release];rectoName=nil;
	[pageView release];pageView=nil;
	[tapForward release];tapForward=nil;
	[tapBack release];tapBack=nil;
	[flipFoward release];flipFoward=nil;
	[flipBack release];flipBack=nil;
	[super dealloc];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	return YES;
}


#pragma mark -
#pragma mark NOTIFICATIONS
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[pageView layoutLayers];
	[self selectedPageDidChange:nil];
}


-(void)selectedPageDidChange:(NSNotification *)aNotification{
	if(UIInterfaceOrientationIsPortrait([self interfaceOrientation])){
		[pageView setThisImageName:[self nameForSelectedPage]];
		[pageView setNextImageName:[self nameForNextPage]];
		[pageView setFlipImageName:rectoName];
		if(NSUIntegerMax == [self previousPageIndex]){
			[pageView setLastImageName:nil];
		}else{
			[pageView setLastImageName:rectoName];
		}

	}else{
		if(selectedPageIndex%2 == 1){ //if page is recto
			if([self nextPageIndex] != NSUIntegerMax){
				[self selectNextPage];
			}			
		}
		
		[pageView setLastImageName:[self nameForPreviousPage]];		
		[pageView setThisImageName:[self nameForSelectedPage]];
		[pageView setFlipImageName:[self nameForNextPage]];
		[pageView setNextImageName:[self nameForNextNextPage]];
	}
}


#pragma mark -
#pragma mark RESPONDER
-(void)doFlipForward:(UIGestureRecognizer *)aGestureRecognizer{
	[pageView doFlipForward:aGestureRecognizer forOrientation:[self interfaceOrientation]];
}


-(void)doFlipBack:(UIGestureRecognizer *)aGestureRecognizer{
	[pageView doFlipBack:aGestureRecognizer forOrientation:[self interfaceOrientation]];
}


-(void)pageFlipped:(id)sender{
	[self selectNextPage];
}


-(void)pageFlippedBack:(id)sender{
	if(UIInterfaceOrientationIsPortrait([self interfaceOrientation])){
		[self selectPreviousPage];
	}else{
		[self selectPreviousPreviousPage];
	}
}


#pragma mark -
#pragma mark DELEGATE
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
	CGSize size = [[self pageView] bounds].size;
  CGFloat touchX = [gestureRecognizer locationInView:[self pageView]].x;

	if((gestureRecognizer == flipFoward || gestureRecognizer == tapForward) 
     && touchX >= (size.width - 88.0f) && [self nextPageIndex] != NSUIntegerMax ){
		return YES;
	}
	
	if((gestureRecognizer == flipBack || gestureRecognizer == tapBack) 
     && touchX <= 88.0f && selectedPageIndex != 0){
		return YES;
	}

	return NO;
}



#pragma mark -
#pragma mark PRIVATE
-(NSUInteger)nextPageIndex{
	if([pageNames count]-1 <= selectedPageIndex){
		return NSUIntegerMax;
	}
	return selectedPageIndex+1;	
}


-(NSUInteger)previousPageIndex{
	if(0 >= selectedPageIndex){
		return NSUIntegerMax;
	}
	return selectedPageIndex-1;
}


-(NSUInteger)nextNextPageIndex{
	NSUInteger nextNextIndex = selectedPageIndex;
	NSUInteger max = [pageNames count]-1;
	if(max <= nextNextIndex){
		return NSUIntegerMax;
	}
	nextNextIndex++;
	if(max <= nextNextIndex){
		return NSUIntegerMax;
	}
	return nextNextIndex+1;
}


-(NSUInteger)previousPreviousPageIndex{
	NSUInteger prevPrevIndex = selectedPageIndex;
	if(0 >= prevPrevIndex){
		return NSUIntegerMax;
	}
	prevPrevIndex--;
	if(0 >= prevPrevIndex){
		return NSUIntegerMax;
	}
	return prevPrevIndex-1;
}


-(void)selectNextPage{
	NSUInteger nextPage = [self nextPageIndex];
	if(NSUIntegerMax == nextPage){
		return;
	}
	selectedPageIndex = nextPage;
	[self selectedPageDidChange:nil];
}


-(void)selectPreviousPage{
	NSUInteger prevPage = [self previousPageIndex];
	if(NSUIntegerMax == prevPage){
		return;
	}
	selectedPageIndex = prevPage;
	[self selectedPageDidChange:nil];
}


-(void)selectPreviousPreviousPage{
	NSUInteger prevPrevPage = [self previousPreviousPageIndex];
	if(NSUIntegerMax == prevPrevPage){
		return;
	}
	selectedPageIndex = prevPrevPage;
	[self selectedPageDidChange:nil];
}


-(NSString *)nameForSelectedPage{
	return (NSString *)[pageNames objectAtIndex:selectedPageIndex];
}


-(NSString *)nameForNextPage{
	NSUInteger index = [self nextPageIndex];
	if(NSUIntegerMax == index){
		return nil;
	}
	return (NSString *)[pageNames objectAtIndex:index];
}


-(NSString *)nameForPreviousPage{
	NSUInteger index = [self previousPageIndex];
	if(NSUIntegerMax == index){
		return nil;
	}
	return (NSString *)[pageNames objectAtIndex:index];
}


-(NSString *)nameForNextNextPage{
	NSUInteger index = [self nextNextPageIndex];
	if(NSUIntegerMax == index){
		return nil;
	}
	return (NSString *)[pageNames objectAtIndex:index];
}

@end
