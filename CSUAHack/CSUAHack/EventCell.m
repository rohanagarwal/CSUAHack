//
//  EventCell.m
//  CSUAHack
//
//  Created by Rohan Agarwal on 3/8/13.
//
//

#import "EventCell.h"

@implementation EventCell
@synthesize organizationLabel = _organizationLabel, nameLabel = _nameLabel, locationLabel = _locationLabel, startDate = _startDate, endDate = _endDate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // organization label
        self.organizationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.organizationLabel setTranslatesAutoresizingMaskIntoConstraints:NO];        
        [self.contentView addSubview:self.organizationLabel];
        NSLayoutConstraint* cn = [NSLayoutConstraint constraintWithItem:self.organizationLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:+5];
        [self.contentView addConstraint:cn];
        
        cn = [NSLayoutConstraint constraintWithItem:self.organizationLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:+2];
        [self.contentView addConstraint:cn];
        // width height of label
        cn = [NSLayoutConstraint constraintWithItem:self.organizationLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:170];
        [self.organizationLabel addConstraint:cn];
        cn = [NSLayoutConstraint constraintWithItem:self.organizationLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20];
        [self.organizationLabel addConstraint:cn];
        
        // name label
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.nameLabel];
        cn = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.organizationLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        [self.contentView addConstraint:cn];
        cn = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.organizationLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:+2];
        [self.contentView addConstraint:cn];
        // width height of label
        cn = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];
        [self.nameLabel addConstraint:cn];
        cn = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20];
        [self.nameLabel addConstraint:cn];
        
        // location label
        self.locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.locationLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.locationLabel];
        cn = [NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.self.organizationLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        [self.contentView addConstraint:cn];
        cn = [NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:+2];
        [self.contentView addConstraint:cn];
        // width height of label
        cn = [NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];
        [self.locationLabel addConstraint:cn];
        cn = [NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20];
        [self.locationLabel addConstraint:cn];
        
        // start date
        self.startDate = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.startDate setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.startDate setNumberOfLines:2];
        [self.contentView addSubview:self.startDate];
        cn = [NSLayoutConstraint constraintWithItem:self.startDate attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.organizationLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        [self.contentView addConstraint:cn];
        cn = [NSLayoutConstraint constraintWithItem:self.startDate attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.organizationLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        [self.contentView addConstraint:cn];
        // width height of label
        cn = [NSLayoutConstraint constraintWithItem:self.startDate attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:120];
        [self.startDate addConstraint:cn];
        cn = [NSLayoutConstraint constraintWithItem:self.startDate attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35];
        [self.startDate addConstraint:cn];
        
        // end date
        self.endDate = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.endDate setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.endDate setNumberOfLines:2];
        [self.contentView addSubview:self.endDate];
        cn = [NSLayoutConstraint constraintWithItem:self.endDate attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.startDate attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [self.contentView addConstraint:cn];
        cn = [NSLayoutConstraint constraintWithItem:self.endDate attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.startDate attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        [self.contentView addConstraint:cn];
        // width height of label
        cn = [NSLayoutConstraint constraintWithItem:self.endDate attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:120];
        [self.endDate addConstraint:cn];
        cn = [NSLayoutConstraint constraintWithItem:self.endDate attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35];
        [self.endDate addConstraint:cn];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
