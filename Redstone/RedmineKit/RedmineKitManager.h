//
//  RKNavigationManager.h
//  RedmineKit
//
//  Created by Rodrigo Recio on 17/04/12.
//  Copyright (c) 2012 Owera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RedmineKit.h"

#define RK_PROJECTS_LOADED_NOTIFICATION @"RKProjectsLoaded"
#define RK_ISSUES_LOADED_NOTIFICATION @"RKIssuesLoaded"
#define RK_JOURNALS_LOADED_NOTIFICATION @"RKJournalsLoaded"

@interface RedmineKitManager : NSObject

@property (unsafe_unretained) id delegate;
@property (strong, nonatomic) RKRedmine *selectedAccount;
@property (strong, nonatomic) RKProject *selectedProject;
@property (strong, nonatomic) RKIssue *selectedIssue;
@property (strong, nonatomic) NSMutableArray *accounts;

+ (RedmineKitManager *)sharedInstance;

- (void)addAccount:(RKRedmine *)account;
- (void)removeAccount:(RKRedmine *)account;
- (void)selectProjectAtIndex:(NSUInteger)index;
- (void)selectIssueAtIndex:(NSUInteger)index;
- (void)selectAccountAtIndex:(NSUInteger)index;

@end
