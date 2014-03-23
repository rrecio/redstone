//
//  OWAppDelegate.m
//  Redstone
//
//  Created by Rodrigo Recio on 22/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWAppDelegate.h"
#import "OWAccountsController.h"
#import "OWIssuesController.h"
#import "OWContainerViewController.h"

@implementation OWAppDelegate

@synthesize window = _window;
@synthesize splitViewController = _splitViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // TestFlight take off :D
//    [TestFlight takeOff:@"22821bff1c1f5400845c2a819d3ec9dc_MjE2MDIyMDExLTA3LTIyIDEzOjQyOjE2LjAzNDM1NQ"];

    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _splitViewController = [[UISplitViewController alloc] init];
    
    OWAccountsController *accountsController = [[OWAccountsController alloc] init];
//    UINavigationController *masterNavController = [[UINavigationController alloc] initWithRootViewController:accountsController];
    OWContainerViewController *masterController = [[OWContainerViewController alloc] initWithContentViewController:accountsController];
    
    OWIssuesController *detailController = [[OWIssuesController alloc] init];
    UINavigationController *detailNavController = [[UINavigationController alloc] initWithRootViewController:detailController];
    
    _splitViewController.viewControllers = [[NSArray alloc] initWithObjects:masterController, detailNavController, nil];
    
    [_window addSubview:_splitViewController.view];
    [_window makeKeyAndVisible];
    
    return YES;
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
