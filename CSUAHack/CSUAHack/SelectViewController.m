//
//  SelectViewController.m
//  CSUAHack
//
//  Created by Rohan Agarwal on 3/8/13.
//
//

#import "SelectViewController.h"
#import "SelectOrgViewController.h"
#import "PersonViewController.h"

@interface SelectViewController ()

@end

@implementation SelectViewController
@synthesize organization = _organization, individual = _individual;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)selectedOrganization:(UIButton *)sender {
    [self performSegueWithIdentifier:@"toSelectOrg" sender:self];
}

- (IBAction)selectedPerson:(UIButton *)sender {
    [self performSegueWithIdentifier:@"toPerson" sender:self];
}

#pragma mark - segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath*)sender {
    if ([segue.identifier isEqualToString:@"toSelectOrg"]) {
        [segue destinationViewController];
    }
    else if ([segue.identifier isEqualToString:@"toPerson"]) {
        [segue destinationViewController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
