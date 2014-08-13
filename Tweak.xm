#define PLIST_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/com.sharedroutine.notifymeagain.plist"]

@interface BBBulletin : NSObject
@property (nonatomic,retain) NSDate * date;
@property (nonatomic,retain) NSDate * endDate;
@property (nonatomic,retain) NSDate * recencyDate; 
@property (nonatomic,retain) NSDate * expirationDate;
@property (nonatomic,retain) NSTimeZone * timeZone; 
@end

@interface SBUIBannerItem : NSObject
-(BBBulletin *)pullDownNotification;
@end

@interface SBUIBannerContext : NSObject
@property (nonatomic,readonly) SBUIBannerItem *item;
-(id)target;
-(id)source;
@end

@protocol SRPickerViewDelegate
@required
-(void)didSelectDelay:(NSNumber *)delay;
@end

@interface SBDefaultBannerView : UIView <SRPickerViewDelegate>
-(id)initWithFrame:(CGRect)frame; 
-(id)initWithContext:(SBUIBannerContext *)context;
-(SBUIBannerContext *)bannerContext;
-(void)nma_initTweak; //new
-(BBBulletin *)nma_bulletin; //new
-(void)notifyMeAgain:(BBBulletin *)bulletin afterDelay:(NSTimeInterval)delay; //new
@end

@interface SBBulletinBannerController : NSObject
+(id)sharedInstance;
-(void)_queueBulletin:(BBBulletin *)bulletin;
@end

NSDictionary *preferences;
float leftDelay,rightDelay;
BOOL enabled;

%hook SBDefaultBannerView 

-(id)initWithFrame:(CGRect)frame {

	self = %orig;

	if (self && enabled) {
		[self nma_initTweak];
	}

	return self;
}

-(id)initWithContext:(SBUIBannerContext *)context {

	self = %orig;

	if (self && enabled) {
		[self nma_initTweak];
	}

	return self;
}

%new

-(void)nma_initTweak {
	UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nma_swipedBannerView:)];
	[rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
	[self addGestureRecognizer:rightSwipe];

	UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nma_swipedBannerView:)];
	[leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
	[self addGestureRecognizer:leftSwipe];
}

%new

-(BBBulletin *)nma_bulletin {
	return [[self bannerContext].item pullDownNotification];
}

%new

-(void)notifyMeAgain:(BBBulletin *)bulletin afterDelay:(NSTimeInterval)delay {
	NSLog(@"Delay For %.f Seconds",delay);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
       	[[%c(SBBulletinBannerController) sharedInstance] _queueBulletin:bulletin];
    });
}

%new

-(void)nma_swipedBannerView:(UISwipeGestureRecognizer *)recognizer {
	if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
		[self notifyMeAgain:[self nma_bulletin] afterDelay:rightDelay];
		NSLog(@"Right Swipe");
	} else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
		[self notifyMeAgain:[self nma_bulletin] afterDelay:leftDelay];
		NSLog(@"Left Swipe");
	}

}

%end

void loadSettings(void) {

	if (preferences) {
		preferences = nil;
	}

	NSLog(@"PLIST_PATH: %@",PLIST_PATH);

	preferences = [NSDictionary dictionaryWithContentsOfFile:PLIST_PATH];
	enabled = [preferences objectForKey:@"kEnabled"] ? [[preferences objectForKey:@"kEnabled"] boolValue] : TRUE;
	if (enabled) {
		leftDelay = [preferences objectForKey:@"kLeftDelay"] ? [[preferences objectForKey:@"kLeftDelay"] floatValue] : 300.0f;
		rightDelay = [preferences objectForKey:@"kRightDelay"] ? [[preferences objectForKey:@"kRightDelay"] floatValue] : 300.0f;
	}
}

%ctor {

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,(CFNotificationCallback)&loadSettings,CFSTR("com.sharedroutine.notifymeagain.settingschanged"),NULL,CFNotificationSuspensionBehaviorDeliverImmediately);
	loadSettings();
}