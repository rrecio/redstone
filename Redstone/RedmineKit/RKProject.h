//
//  Project.h
//  RedmineKit
//
//  Created by Rodrigo Recio on 15/11/11.
//  Copyright (c) 2011 Owera. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RKIssueSortById = 1,
    RKIssueSortByTracker = 2,
    RKIssueSortByStatus = 3,
    RKIssueSortByPriority = 4,
    RKIssueSortByCategory = 5, 
    RKIssueSortByAssignedTo = 6,
    RKIssueSortByFixedVersion = 7,
    RKIssueSortByStartDate = 8,
    RKIssueSortByDueDate = 9,
    RKIssueSortByEstimatedHours = 10,
    RKIssueSortByDone = 11
} RKIssueSortBy;

@class RKValue;
@class RKIssue;
@class RKIssueOptions;
@class RKRedmine;
@interface RKProject : NSObject
{
    NSUInteger issuesPageCount;
    NSUInteger totalIssues;
    NSUInteger pageOffset;
}

@property (nonatomic) NSString *identifier;
@property (nonatomic) NSString *homepage;
@property (nonatomic) NSDate *createdOn;
@property (nonatomic) NSString *name;
@property (nonatomic) NSDate *updatedOn;
@property (nonatomic) NSString *projectDescription;
@property (nonatomic) NSNumber *index;
@property (nonatomic) RKValue *parent;
@property (nonatomic) NSMutableArray *issues;
@property (nonatomic) RKRedmine *redmine;
@property (nonatomic) RKIssueSortBy sortIssuesBy;
@property (nonatomic) NSNumber *orderIssuesDesc;

+ (RKProject *)projectForProjectDict:(NSDictionary *)projectDict;
/**
 * method to get a specific issue
 */
- (RKIssue *)issueForIndex:(NSNumber *)index;

/**
 * method to paginate through issue list (by 25 items per page)
 */
- (void)loadMoreIssues;

/**
 * method used to figure out if all issues were already loaded;
 */
- (BOOL)isLastPage;

/**
 * method to post new issue
 */
- (BOOL)postNewIssue:(RKIssue *)issue;

/**
 * method that gets the currently available options for the new issue on current project
 * (ex.: versions, priorities, project members, etc.)
 */
- (RKIssueOptions *)newIssueOptions;

@end