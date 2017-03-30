//
//  MTEiPadAgendaMonthViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 9/5/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEiPadAgendaViewController.h"
#import "MTEday.h"
#import "MTEcita.h"
#import "MTEpaciente.h"
#import "MTEEntidad.h"

@interface MTEiPadAgendaMonthViewController : UICollectionViewController
@property (nonatomic) int monthShowing;
@property (nonatomic) int yearShowing;
@property (nonatomic) int currentDay;
@property (nonatomic) int currentMonth;
@property (nonatomic) int currentYear;
@property (nonatomic, strong) MTEday *currentDate;
@property (nonatomic, strong) MTEconsultorio *consul;
@property (nonatomic, strong) MTEiPadAgendaViewController *avc;
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) NSMutableArray *citas;

- (void)fillDaysArray;
- (void)cargarCitas;

@end
