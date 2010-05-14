/* 
 If you find this code useful, please consider downloading a copy of the app that spawned it ( http://itunes.com/apps/VERVM ) and leaving a review.
 
 My thanks,
 -Joshua Emmons
 @jemmons
 
 */

@class VCBookViewController;

@interface VCAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	VCBookViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet VCBookViewController *viewController;

@end

