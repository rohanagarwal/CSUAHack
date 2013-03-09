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
    
    // add to calendar
    UIBarButtonItem* syncButton = [[UIBarButtonItem alloc] initWithTitle:@"Sync all to iCal" style:UIBarButtonItemStylePlain target:self action:@selector(syncEvents)];
    self.navigationItem.rightBarButtonItem = syncButton;
    
    self.allEvents = [[NSMutableArray alloc] init];
 //   [self.allEvents addObject:@"Event test"];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setRowHeight:75];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundView:nil];
    [self.tableView registerClass:[EventCell class] forCellReuseIdentifier:@"EventCell"];
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
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
    switch (action) {
		case EKEventEditViewActionCanceled:
			// Adding the event was cancelled.
            NSLog(@"CANCELLED");
			break;
            
		case EKEventEditViewActionSaved:
			// The event was saved
            NSLog(@"SAVED");
			break;
            
		case EKEventEditViewActionDeleted:
			// The event was deleted
            NSLog(@"DELETED");
			break;
            
		default:
			break;
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
