//
//  OWTimeTrackController.m
//  Redstone
//
//  Created by Tales Pinheiro De Andrade on 06/05/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWTimeTrackController.h"
#import "RedmineKitManager.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

#define kTimerInterval		0.1f


@interface OWTimeTrackController () {
    RedmineKitManager *manager;
    NSTimer *timer;
    CFTimeInterval _ticks;
    BOOL timerActivated;
    RKTimeEntry *timeEntry;
    RKIssue *_issue;
}
- (void)startTimer:(NSTimeInterval)timerInterval;
@end

@implementation OWTimeTrackController
@synthesize playButton, stopButton, taskButton, timeLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        timeEntry = [[RKTimeEntry alloc] init];
        // Custom initialization
        self.view.backgroundColor = [UIColor lightGrayColor];
        CGRect frame = CGRectMake(20, 20, 280, 40);
        taskButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        taskButton.frame = frame;
        [taskButton addTarget:self action:@selector(task:) forControlEvents:UIControlEventTouchDown];
        [taskButton setTitle:@"TASK" forState:UIControlStateNormal];
        [self.view addSubview:taskButton];
        
        frame.origin.y += 60;
        timeLabel = [[UILabel alloc] initWithFrame:frame];
        timeLabel.text = @"00:00";
        timeLabel.textAlignment = UITextAlignmentCenter;
        timeLabel.font = [UIFont systemFontOfSize:30];
        timeLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:timeLabel];
        
        frame = CGRectMake(80, 140, 40, 40);
        playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        playButton.frame = frame;
        [playButton setImage:[UIImage imageNamed:@"16-play"] forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchDown];
        playButton.enabled = NO;
        [self.view addSubview:playButton];
        
        frame.origin.x += 120;
        stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        stopButton.frame = frame;
        [stopButton setImage:[UIImage imageNamed:@"18-stop"] forState:UIControlStateNormal];
        [stopButton addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchDown];
        stopButton.enabled = NO;
        [self.view addSubview:stopButton];
        
        self.view.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.view.layer.borderWidth = 0.5f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    manager = [RedmineKitManager sharedInstance];
    [manager addObserver:self forKeyPath:@"selectedIssue" options:NSKeyValueChangeSetting context:nil];
    [manager addObserver:self forKeyPath:@"selectedIssue" options:NSKeyValueChangeInsertion context:nil];
    [manager addObserver:self forKeyPath:@"selectedIssue" options:NSKeyValueChangeRemoval context:nil];
    [manager addObserver:self forKeyPath:@"selectedIssue" options:NSKeyValueChangeReplacement context:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Timer
- (void)play:(id)sender
{
	if (!timerActivated) {
        NSLog(@"playing...");
        [self startTimer:kTimerInterval];
        [playButton setImage:[UIImage imageNamed:@"17-pause"] forState:UIControlStateNormal];
    }
    else {
        NSLog(@"Paused.");
        [playButton setImage:[UIImage imageNamed:@"16-play"] forState:UIControlStateNormal];
        timerActivated = NO;
    }
}

- (void)stop:(id)sender
{
    NSLog(@"STOPADO!");
    if (timerActivated) {
        timerActivated = NO;
        _ticks = 0;
        [playButton setImage:[UIImage imageNamed:@"16-play"] forState:UIControlStateNormal];
        [self stopTimer];
    }
}

- (void)startTimer:(NSTimeInterval)timerInterval
{
    NSLog(@"Starting timer");
	if (!timerActivated) {
        timerActivated = YES;
        if (timer == nil) {
            timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
        }
    }
}

- (void)stopTimer
{
    NSLog(@"Stoped.");
	timeLabel.text = @"00:00:00";
    timerActivated = NO;
    [timer invalidate];
    timer = nil;
    OWIssueUpdateController *updateController = [[OWIssueUpdateController alloc] init];
    updateController.delegate = self;
    updateController.timeEntry.hours = timeEntry.hours;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:updateController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:navController animated:YES];
}

- (void)timerTick: (NSTimer *) timer
{
    if (timerActivated) {
        _ticks += 0.1;
        double seconds = fmod(_ticks, 60.0);
        double minutes = fmod(trunc(_ticks / 60.0), 60.0);
        double hours = trunc(_ticks / 3600.0);
        timeLabel.text = [NSString stringWithFormat:@"%02.0f:%02.0f:%02.0f", hours, minutes, seconds];
        
        timeEntry.hours = [NSNumber numberWithDouble:(minutes/60 + hours)];
    }
}

- (void)task:(id)sender
{
    NSLog();
}

#pragma mark - Post timer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == manager)
	{
        if ([change valueForKey:@"old"] && [change valueForKey:@"new"]) {
            NSLog(@"change: %@", change);
            NSLog(@"New   : %@", [[change valueForKey:@"new"] class]);
            NSLog(@"Old   : %@", [[change valueForKey:@"old"] class]);

            if ([[change valueForKey:@"old"] class] == [NSNull class]) {
                [taskButton setTitle:[NSString stringWithFormat:@"%@", manager.selectedIssue.subject] forState:UIControlStateNormal];
                playButton.enabled = YES;
                stopButton.enabled = YES;
                _issue = manager.selectedIssue;
            }
            else if ([change valueForKey:@"old"] == [change valueForKey:@"new"]) {
                NSLog(@"nada a fazer, iguais");
            }
            else {
                NSLog(@"aqui deve parar, trocou de tarefa...");
                _issue = [change valueForKey:@"old"];
                [self stop:nil];
            }
        }
	}
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark - ListController Delegate Methods
- (void)listController:(OWListController *)controller didSelectItemOnIndex:(NSUInteger)index
{
    
    if (controller.list.count > 0) {
        if ([controller.identifier isEqualToString:@"Activity"]) {
            timeEntry.activity = [controller.list objectAtIndex:index];
            NSLog(@"timeEntry.activity: %@", [timeEntry.activity class]);
        }
//        [self.tableView reloadData];
    }
}

- (void)issueUpdateControllerDidDismissed:(OWIssueUpdateController *)issueUpdateController
{
//    self.hasChanges = YES;
}

@end
