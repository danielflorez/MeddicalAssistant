//
//  MTEiPadDayAgendaTableViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 9/8/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEday.h"
#import "MTEiPadAgendaViewController.h"
#import "MTEcita.h"

@interface MTEiPadDayAgendaTableViewController : UITableViewController
@property (nonatomic, strong) MTEday *day;
@property (nonatomic, strong) NSMutableArray *hours;
@property (nonatomic, strong) MTEiPadAgendaViewController *avc;
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) NSMutableArray *citas;

- (void)cargarHoras;

@end
