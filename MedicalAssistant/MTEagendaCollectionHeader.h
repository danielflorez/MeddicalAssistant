//
//  MTEagendaCollectionHeader.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 9/3/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEiphoneAgendaMonthCollectionViewController.h"

@interface MTEagendaCollectionHeader : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *sundayLabel;
@property (weak, nonatomic) IBOutlet UILabel *mondayLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuesdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *wednesdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *thursdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *fridayLabel;
@property (weak, nonatomic) IBOutlet UILabel *saturdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (nonatomic, strong) MTEiphoneAgendaMonthCollectionViewController *amvc;

@end
