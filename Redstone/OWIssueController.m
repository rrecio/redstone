//
//  OWIssueController.m
//  Redstone
//
//  Created by Rodrigo Recio on 02/03/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWIssueController.h"
#import "OWIssueOverviewCell.h"
#import "OWJournalCell.h"
#import "RKParseHelper.h"
#import "RedmineKitManager.h"
#import "OWIssueUpdateController.h"

@interface OWIssueController ()

@end

@implementation OWIssueController

@synthesize issue, hasChanges;

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    self.title = @"Issue";
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStyleBordered target:self action:@selector(updateButtonTapped:)];
}

- (void)updateButtonTapped:(id)sender
{
    OWIssueUpdateController *updateController = [[OWIssueUpdateController alloc] init];
    updateController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:updateController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:navController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    issue = [[RedmineKitManager sharedInstance] selectedIssue];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.hasChanges = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return issue.journals.count;
    } else {
        return 1;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"UpdateIssue"]) {
        UINavigationController *nav = [segue destinationViewController];
        OWIssueUpdateController *issueUpdateController = (OWIssueUpdateController *)[nav topViewController];
        issueUpdateController.issue = issue;
        issueUpdateController.delegate = self;
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *overviewCell = @"OverviewCell";
    static NSString *descCell = @"DescCell";
    
    if (indexPath.section == 0) {
        OWIssueOverviewCell *cell = (OWIssueOverviewCell *)[self.tableView dequeueReusableCellWithIdentifier:overviewCell];
        
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"OWIssueOverviewCell" owner:self options:NULL];
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        cell.subjectLabel.text          = issue.subject;
        NSString *addedBy               = NSLocalizedString(@"Added by %@. %@", nil);
        cell.addedByAuthorLabel.text    = [NSString stringWithFormat:addedBy, issue.author.name, [RKParseHelper shortDateStringFromDate:issue.createdOn]];
        cell.statusLabel.text           = issue.status.name;
        cell.priorityLabel.text         = issue.priority.name;
        cell.versionLabel.text          = issue.fixedVersion.name;
        cell.categoryLabel.text         = issue.category.name;
        cell.assignedToLabel.text       = issue.assignedTo.name;
        cell.startLabel.text            = [RKParseHelper shortDateStringFromDate:issue.startDate];
        cell.dueLabel.text              = [RKParseHelper shortDateStringFromDate:issue.dueDate];
        cell.doneRatioLabel.text        = [[issue.doneRatio stringValue] stringByAppendingString:@" %"];
        cell.spentTimeLabel.text        = [[issue.spentHours stringValue] stringByAppendingString:@" hours"];
        
        return cell;
    }
    if (indexPath.section == 1) {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:descCell];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:descCell];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.adjustsFontSizeToFitWidth = NO;
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        }
        
        cell.textLabel.text = issue.issueDescription;
        
        return cell;
    }
    if (indexPath.section == 2) {
        RKJournal *journal = [issue.journals objectAtIndex:indexPath.row];
        OWJournalCell *cell = [self.tableView dequeueReusableCellWithIdentifier:journal.description];
        if (cell == nil) {
            cell = [[OWJournalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:journal.description];
            cell.journal = journal;
        }
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [issue.tracker.name stringByAppendingFormat:@" #%@", issue.index];
    }
    if (section == 1) {
        return NSLocalizedString(@"Description", nil);
    }
    if (section == 2) {
        if (issue.journals.count > 0) {
            return NSLocalizedString(@"History", nil);
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize boundingSize = CGSizeMake(600, CGFLOAT_MAX);
    if (indexPath.section == 0) {
        return 236;
    }
    if (indexPath.section == 1) {
        CGSize descriptionSize = [issue.issueDescription sizeWithFont:[UIFont boldSystemFontOfSize:17.0] constrainedToSize:boundingSize lineBreakMode:UILineBreakModeWordWrap];
        return descriptionSize.height + 40;
    }
    if (indexPath.section == 2) {
        CGFloat yOrig = 20;
        CGFloat height = 15;
        RKJournal *journal = [issue.journals objectAtIndex:indexPath.row];
        CGSize notesSize = [journal.notes sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:boundingSize lineBreakMode:UILineBreakModeWordWrap];
        return (yOrig*(journal.details.count+2))+(height*journal.details.count)+notesSize.height;
    }
    return 44;
}

- (void)issueUpdateControllerDidDismissed:(OWIssueUpdateController *)issueUpdateController
{
    [self.tableView reloadData];
    
    self.hasChanges = YES;
}

@end
