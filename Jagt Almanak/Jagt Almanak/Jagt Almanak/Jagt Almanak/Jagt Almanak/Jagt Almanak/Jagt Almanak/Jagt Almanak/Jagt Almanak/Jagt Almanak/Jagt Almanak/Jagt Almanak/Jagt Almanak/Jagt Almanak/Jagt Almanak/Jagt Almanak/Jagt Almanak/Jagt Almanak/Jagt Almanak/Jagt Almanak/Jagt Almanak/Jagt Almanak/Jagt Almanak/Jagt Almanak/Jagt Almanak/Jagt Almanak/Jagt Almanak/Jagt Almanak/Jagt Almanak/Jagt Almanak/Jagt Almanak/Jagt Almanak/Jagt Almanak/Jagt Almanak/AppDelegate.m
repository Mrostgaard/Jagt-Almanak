//
//  AppDelegate.m
//  Jagt Almanak
//
//  Created by Mark Mortensen on 14/04/13.
//  Copyright (c) 2013 4FunAndProfit. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.
    return YES;
    
    //Bruges til 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //Sætter vores userdefaults til 0
    antalMin = 0;
    alarmKey = 0;
    
    //Her sætter vi først vores antalMin som er den værdi vi bruger til at beregne hvor længe inden solnedgang alarmen skal lyde
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger antalMin = [defaults integerForKey:@"antalMin"];
    
    [defaults synchronize];
    
    //Vi skal også instantisierer en userdefaults for vores alarmValue
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger alarmValue = [prefs integerForKey:@"alarmKey"];
    
    [prefs synchronize];
    
    
    //hopefully remove the icon badge
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    
     /*
     alarValue:
     0 = off
     1 = on, before sunset
     2 = on, after sunset = alarm on sunrise
     */
    
    
    
    /*MENU METODER!!*/
    //Making the images used in the menu item
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    //hopefully remove the icon badge
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
