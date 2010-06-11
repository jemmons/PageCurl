/* 
 This code is licensed under a Simplified BSD License. See LICENSE for details.
 If you find this code useful, please consider downloading a copy of the app that spawned it ( http://itunes.com/apps/VERVM ) and leaving a review.
 
 My thanks,
 -Joshua Emmons
 @jemmons
 
 */


#import <QuartzCore/QuartzCore.h>
@interface VCPageLayer : CALayer {
	NSString *imageName;
	NSString *path;
}
@property(nonatomic,copy)NSString *imageName;
@end
