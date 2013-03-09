//
//  PersonViewController.m
//  CSUAHack
//
//  Created by Rohan Agarwal on 3/8/13.
//
//

#import "PersonViewController.h"
#import "CSUAType.h"
#import "BumpClient.h"
#import <EventKit/EventKit.h>
#import "EventObj.h"
#import "EventCell.h"
#import <QuartzCore/QuartzCore.h>

@interface PersonViewController ()

@property (strong, nonatomic) NSMutableArray* allEvents;
@property (strong, nonatomic) EKEventStore* store;

@end

@implementation PersonViewController
@synthesize allEvents = _allEvents, store = _store;
@synthesize connectedState = _connectedState, connectionInfo = _connectionInfo, tableView = _tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.store = [[EKEventStore alloc] init];
    
    [self configureBump];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    
    [self.connectedState.layer setShadowOpacity:1.0];
    [self.connectedState.layer setShadowRadius:1.0];
    [self.connectedState.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.connectedState.layer setShadowOffset:CGSizeMake(-0.5, 0.5)];
    
    [self.connectionInfo.layer setShadowOpacity:1.0];
    [self.connectionInfo.layer setShadowRadius:1.0];
    [self.connectionInfo.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.connectionInfo.layer setShadowOffset:CGSizeMake(-0.5, 0.5)];
    
    // add to calendar
    UIBarButtonItem* syncButton = [[UIBarButtonItem alloc] initWithTitle:@"Sync all to iCal" style:UIBarButtonItemStylePlain target:self action:@selector(syncEvents)];
    self.navigationItem.rightBarButtonItem = syncButton;
    
    self.allEvents = [[NSMutableArray alloc] init];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setRowHeight:75];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundView:nil];
    [self.tableView registerClass:[EventCell class] forCellReuseIdentifier:@"EventCell"];
}
-(void) viewWillAppear:(BOOL)animated {
    [self.connectionInfo setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
}
- (IBAction)share:(id)sender {
    NSLog(@"allEvents: %@", self.allEvents);
    if ([self.allEvents count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No events to share!" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
    NSString *textShare = @"I discovered some cool events including ";
    
    NSMutableArray* copy = [[NSMutableArray alloc] init];
    [copy addObjectsFromArray:self.allEvents];
    for (EventObj* event in copy) {
        NSString* toAdd = event.eventName;
        textShare = [[textShare stringByAppendingString:toAdd] stringByAppendingString:@", "];
    }
    textShare = [textShare substringToIndex:[textShare length] - 2];
    textShare = [textShare stringByAppendingString:@". Check out this app called EventMe!"];
    
    NSArray *activityItems = @[textShare];
    UIActivityViewController *avc =
    [[UIActivityViewController alloc]
     initWithActivityItems:activityItems applicationActivities:nil];
    
    NSArray* exclude = @[UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard];
    avc.excludedActivityTypes = exclude;
    [self presentViewController:avc animated:YES completion:nil];
    
    }
}
- (void) configureBump {
    // userID is a string that you could use as the user's name, or an ID that is semantic within your environment
    [BumpClient configureWithAPIKey:BumpAPI andUserID:[[UIDevice currentDevice] name]];
    
    [[BumpClient sharedClient] setMatchBlock:^(BumpChannelID channel) {
        NSLog(@"Matched with user: %@", [[BumpClient sharedClient] userIDForChannel:channel]);
        [[BumpClient sharedClient] confirmMatch:YES onChannel:channel];
    }];
    
    [[BumpClient sharedClient] setChannelConfirmedBlock:^(BumpChannelID channel) {
        NSLog(@"Channel with %@ confirmed.", [[BumpClient sharedClient] userIDForChannel:channel]);
        [self.connectionInfo setHidden:YES];
        self.connectedState.text = @"Connected";
    }];
    
    [[BumpClient sharedClient] setDataReceivedBlock:^(BumpChannelID channel, NSData *data) {
        // create event objects, update array, reload table
        self.allEvents = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self.tableView reloadData];
    }];
    
    
    // optional callback
    [[BumpClient sharedClient] setConnectionStateChangedBlock:^(BOOL connected) {
        if (connected) {
            NSLog(@"Bump connected...");
        } else {
            NSLog(@"Bump disconnected...");
        }
    }];
    
    // optional callback
    [[BumpClient sharedClient] setBumpEventBlock:^(bump_event event) {
        switch(event) {
            case BUMP_EVENT_BUMP:
                NSLog(@"Bump detected.");
                break;
            case BUMP_EVENT_NO_MATCH:
                NSLog(@"No match.");
                break;
        }
    }];
}

#pragma tableview methods
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Events Received";
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {// custom view for header. will be adjusted to default or specified header height
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(30, 0, 300, 40);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.text = @"   Events Received";
    headerLabel.textColor = [UIColor whiteColor];
    [headerLabel.layer setShadowOpacity:1.0];
    [headerLabel.layer setShadowRadius:1.0];
    [headerLabel.layer setShadowColor:[UIColor blackColor].CGColor];
    [headerLabel.layer setShadowOffset:CGSizeMake(-0.5, 0.5)];
    // headerLabel.textAlignment = NSTextAlignmentCenter;
    UIView* view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor greenColor]];
    return headerLabel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allEvents count];
}

- (EventCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    EventObj* obj = (EventObj*)[self.allEvents objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.organizationLabel.text = obj.organizationName;
    cell.organizationLabel.font = [UIFont systemFontOfSize:13.0];
    cell.organizationLabel.textColor = [UIColor darkTextColor];
    cell.nameLabel.text = obj.eventName;
    cell.nameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    cell.nameLabel.textColor = [UIColor blackColor];
    cell.locationLabel.text = obj.location;
    cell.locationLabel.font = [UIFont italicSystemFontOfSize:12.0];
    cell.locationLabel.textColor = [UIColor blackColor];
    cell.startDate.text = [obj StringStartDate];
    cell.startDate.font = [UIFont systemFontOfSize:12.0];
    cell.startDate.textColor = [UIColor blackColor];
    cell.endDate.text = [obj StringEndDate];
    cell.endDate.font = [UIFont systemFontOfSize:12.0];
    cell.endDate.textColor = [UIColor blackColor];
    
    
    [cell.organizationLabel.layer setShadowOpacity:1.0];
    [cell.organizationLabel.layer setShadowRadius:1.0];
    [cell.organizationLabel.layer setShadowColor:[UIColor blackColor].CGColor];
    [cell.organizationLabel.layer setShadowOffset:CGSizeMake(-0.5, 0.5)];
    
    [cell.nameLabel.layer setShadowOpacity:1.0];
    [cell.nameLabel.layer setShadowRadius:1.0];
    [cell.nameLabel.layer setShadowColor:[UIColor blackColor].CGColor];
    [cell.nameLabel.layer setShadowOffset:CGSizeMake(-0.5, 0.5)];
    
    [cell.locationLabel.layer setShadowOpacity:1.0];
    [cell.locationLabel.layer setShadowRadius:1.0];
    [cell.locationLabel.layer setShadowColor:[UIColor blackColor].CGColor];
    [cell.locationLabel.layer setShadowOffset:CGSizeMake(-0.5, 0.5)];
    
    [cell.startDate.layer setShadowOpacity:1.0];
    [cell.startDate.layer setShadowRadius:1.0];
    [cell.startDate.layer setShadowColor:[UIColor blackColor].CGColor];
    [cell.startDate.layer setShadowOffset:CGSizeMake(-0.5, 0.5)];
    
    [cell.endDate.layer setShadowOpacity:1.0];
    [cell.endDate.layer setShadowRadius:1.0];
    [cell.endDate.layer setShadowColor:[UIColor blackColor].CGColor];
    [cell.endDate.layer setShadowOffset:CGSizeMake(-0.5, 0.5)];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        NSLog(@"made it here");
        // handle access here
    }];
    EKEvent* event = [self EKEventFromEventObj:[self.allEvents objectAtIndex:indexPath.row]];
    EKEventEditViewController * controller = [[EKEventEditViewController alloc] init];
    controller.eventStore = self.store;
    controller.event = event;
    controller.editViewDelegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

-(void) syncEvents {
    [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        NSLog(@"made it here");
        // handle access here
    }];
    for (EventObj* obj in self.allEvents) {
        EKEvent* event = [self EKEventFromEventObj:obj];
        NSError* error;
        NSLog(@"result: %d", [self.store saveEvent:event span:EKSpanThisEvent commit:YES error:&error]);
        NSLog(@"error is: %@", error);
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successfully added all events!" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
    switch (action) {
		case EKEventEditViewActionCanceled:
        {
			// Adding the event was cancelled.
            NSLog(@"CANCELLED");
			break;
        }
		case EKEventEditViewActionSaved:
        {
			// The event was saved
            NSLog(@"SAVED");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successfully added event!" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
			break;
        }
		case EKEventEditViewActionDeleted:
        {
			// The event was deleted
            NSLog(@"DELETED");
			break;
        }
		default:
        {
			break;
        }
	}
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(EKEvent*) EKEventFromEventObj:(EventObj*) obj {
    EKEvent* event = [EKEvent eventWithEventStore:self.store];
    event.title = [[obj.organizationName stringByAppendingString:@": "] stringByAppendingString:obj.eventName];
    event.startDate = obj.startDate;
    event.endDate = obj.endDate;
    event.location = obj.location;
    event.calendar = [self.store defaultCalendarForNewEvents];
    return event;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
