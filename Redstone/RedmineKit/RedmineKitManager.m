//
//  RKNavigationManager.m
//  RedmineKit
//
//  Created by Rodrigo Recio on 17/04/12.
//  Copyright (c) 2012 Owera. All rights reserved.
//

#import "RedmineKitManager.h"

#define RK_ACCOUNTS_ARRAY_KEY @"RKAccounts"

@implementation RedmineKitManager

@synthesize selectedAccount=_selectedAccount;
@synthesize selectedProject=_selectedProject;
@synthesize selectedIssue=_selectedIssue;
@synthesize accounts=_accounts;
@synthesize delegate;

+ (RedmineKitManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    static RedmineKitManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[RedmineKitManager alloc] init];
    });    
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Load accounts
        
        // Try loading archived array of accounts
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
        NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:RK_ACCOUNTS_ARRAY_KEY];
        if (dataRepresentingSavedArray != nil) {
            NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
            if (oldSavedArray != nil)
                _accounts = [[NSMutableArray alloc] initWithArray:oldSavedArray];
        }
        
        // If there's no archived accounts array, instantiate one so its archived when a new account is added
        if (_accounts == nil) {
            _accounts = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

# pragma mark - Helper methods

- (void)addAccount:(RKRedmine *)account
{
    [_accounts addObject:account];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_accounts] forKey:RK_ACCOUNTS_ARRAY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeAccount:(RKRedmine *)account
{
    [_accounts removeObject:account];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_accounts] forKey:RK_ACCOUNTS_ARRAY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)selectProjectAtIndex:(NSUInteger)index
{
    _selectedProject = [_selectedAccount.projects objectAtIndex:index];
}

- (void)selectIssueAtIndex:(NSUInteger)index
{
    _selectedIssue = [_selectedProject.issues objectAtIndex:index];
}

- (void)selectAccountAtIndex:(NSUInteger)index
{
    _selectedAccount = [_accounts objectAtIndex:index];
}

@end
