#import <Preferences/Preferences.h>

@interface NotifyMeAgainPrefsListController: PSListController {
}
@end

@implementation NotifyMeAgainPrefsListController

-(void)setEnabled:(NSNumber *)enabled forSpecifier:(PSSpecifier *)spec {

	[self setPreferenceValue:enabled specifier:spec];
	[[NSUserDefaults standardUserDefaults] synchronize];

	[((PSSpecifier *)[self specifierForID:@"leftdelay"]) setProperty:@(([enabled intValue] == 1)) forKey:@"enabled"];
	[((PSSpecifier *)[self specifierForID:@"rightdelay"]) setProperty:@(([enabled intValue] == 1)) forKey:@"enabled"];
	[self reloadSpecifierID:@"leftdelay"];
	[self reloadSpecifierID:@"rightdelay"];
}

-(NSNumber *)getEnabledForSpecifier:(PSSpecifier *)spec {
	return [self readPreferenceValue:spec];
}

-(NSArray *)validTitles:(PSSpecifier *)spec {

	return @[@"1 Minute",
				@"2 Minutes",
				@"3 Minutes",
				@"4 Minutes",
				@"5 Minutes",
				@"10 Minutes",
				@"25 Mintes",
				@"45 Minutes",
				@"1 Hour",
				@"1.5 Hours",
				@"2 Hours",
				@"5 Hours",
				@"10 Hours",
				@"12 Hours",
				@"1 Day"];
		
}

-(NSArray *)validValues:(PSSpecifier *)spec {

	return @[@(60.0f),
				@(120.0f),
				@(180.0f),
				@(240.0f),
				@(300.0f),
				@(600.0f),
				@(1500.0f),
				@(2700.0f),
				@(3600.0f),
				@(5400.0f),
				@(7200.0f),
				@(18000.0f),
				@(36000.0f),
				@(43200.0f),
				@(86400.0f)];
}

-(void)viewDidLoad {

	[super viewDidLoad];

	if ([[self readPreferenceValue:[self specifierForID:@"enableswitch"]] intValue] == 1) {
		[((PSSpecifier *)[self specifierForID:@"leftdelay"]) setProperty:@(TRUE) forKey:@"enabled"];
		[((PSSpecifier *)[self specifierForID:@"rightdelay"]) setProperty:@(TRUE) forKey:@"enabled"];
		[self reloadSpecifierID:@"leftdelay"];
		[self reloadSpecifierID:@"rightdelay"];
	}
}

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"NotifyMeAgainPrefs" target:self];
	}
	return _specifiers;
}
@end

// vim:ft=objc
