/* 
 If you find this code useful, please consider downloading a copy of the app that spawned it ( http://itunes.com/apps/VERVM ) and leaving a review.
 
 My thanks,
 -Joshua Emmons
 @jemmons

 */

#import "VCAppDelegate.h"
#import "VCBookViewController.h"

@implementation VCAppDelegate
@synthesize window, viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {   
  
	[window addSubview:viewController.view];
	[window makeKeyAndVisible];

  //We have to call this after a loop because it relies on orientation (which is "unknown" until after a go through the run loop).
  [viewController performSelector:@selector(selectedPageDidChange:) withObject:nil afterDelay:0];
  
	return YES;
}


-(void)dealloc {
	[viewController release]; viewController=nil;
	[window release];window=nil;
	[super dealloc];
}




@end
