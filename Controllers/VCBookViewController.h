/* 
 If you find this code useful, please consider downloading a copy of the app that spawned it ( http://itunes.com/apps/VERVM ) and leaving a review.
 
 My thanks,
 -Joshua Emmons
 @jemmons
 
 */


@class VCPageView;
@interface VCBookViewController : UIViewController <UIGestureRecognizerDelegate> {
	VCPageView *pageView;
	NSArray *pageNames;
	NSString *rectoName;
	NSUInteger selectedPageIndex;
	UIPanGestureRecognizer *flipFoward;
	UIPanGestureRecognizer *flipBack;
  UITapGestureRecognizer *tapForward;
  UITapGestureRecognizer *tapBack;
}
@property(nonatomic, retain) IBOutlet VCPageView *pageView;
@property(nonatomic, retain) NSArray *pageNames;
@property(nonatomic, retain) NSString *rectoName;

-(void)pageFlipped:(id)sender;
-(void)pageFlippedBack:(id)sender;
-(void)selectedPageDidChange:(NSNotification *)aNotification;
@end

