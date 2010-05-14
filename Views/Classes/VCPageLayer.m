/* 
 If you find this code useful, please consider downloading a copy of the app that spawned it ( http://itunes.com/apps/VERVM ) and leaving a review.
 
 My thanks,
 -Joshua Emmons
 @jemmons
 
 */


#import "VCPageLayer.h"
@implementation VCPageLayer

-(id)init{
	if(self = [super init]){
		path = [[[NSBundle mainBundle] resourcePath] copy];
	}
	return self;
}


-(void)dealloc{
	[imageName release];imageName=nil;
	[path release];path=nil;
	[super dealloc];
}


-(NSString *)imageName{
	return imageName;
}


-(void)setImageName:(NSString *)aName{
	NSString *oldName = imageName;
	imageName = [aName copy];
	[oldName release];
	
	if(nil == aName ){
		[self setContents:nil];
		return;
	}
	
	CGDataProviderRef provider = CGDataProviderCreateWithFilename([[path stringByAppendingPathComponent:aName] UTF8String]);
  CGImageRef image = CGImageCreateWithPNGDataProvider(provider, NULL, NO, kCGRenderingIntentDefault);
  CGDataProviderRelease(provider);
	[self setContents:(id)image];
	CGImageRelease(image);
}

@end
