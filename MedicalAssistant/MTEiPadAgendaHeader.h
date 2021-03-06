//
//  MTEiPadAgendaHeader.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 9/8/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEiPadAgendaMonthViewController.h"

@interface MTEiPadAgendaHeader : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *sundayLabel;
@property (weak, nonatomic) IBOutlet UILabel *mondayLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuedayLabel;
@property (weak, nonatomic) IBOutlet UILabel *wednesdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *thursdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *fridayLabel;
@property (weak, nonatomic) IBOutlet UILabel *saturdayLabel;
@property (nonatomic, strong) MTEiPadAgendaMonthViewController *amvc;


@end
