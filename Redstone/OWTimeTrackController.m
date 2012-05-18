//
//  OWTimeTrackController.m
//  Redstone
//
//  Created by Tales Pinheiro De Andrade on 06/05/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWTimeTrackController.h"
#import "QuartzCore/QuartzCore.h"

#define kTimerInterval		0.1f


@interface OWTimeTrackController () {
    NSTimer *timer;
    CFTimeInterval _ticks;
    BOOL timerActivated;
}
- (void)startTimer:(NSTimeInterval)timerInterval;
@end

@implementation OWTimeTrackController
@synthesize playButton, stopButton, taskButton, timeLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
        [self.view addSubview:playButton];
        
        frame.origin.x += 120;
        stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        stopButton.frame = frame;
        [stopButton setImage:[UIImage imageNamed:@"18-stop"] forState:UIControlStateNormal];
        [stopButton addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:stopButton];
        
        self.view.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.view.layer.borderWidth = 1.0f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    [self stopTimer];
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
}

- (void)timerTick: (NSTimer *) timer
{
    if (timerActivated) {
        _ticks += 0.1;
        double seconds = fmod(_ticks, 60.0);
        double minutes = fmod(trunc(_ticks / 60.0), 60.0);
        double hours = trunc(_ticks / 3600.0);
        timeLabel.text = [NSString stringWithFormat:@"%02.0f:%02.0f:%02.0f", hours, minutes, seconds];
    }
}

- (void)task:(id)sender
{
    NSLog();
}
@end
