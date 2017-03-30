//
//  MTEiphoneAgendaMonthCollectionViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 11/13/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEconsultorio.h"
#import "MTEcita.h"
#import "MTEpaciente.h"

@interface MTEiphoneAgendaMonthCollectionViewController : UICollectionViewController
@property (nonatomic) int monthShowing;
@property (nonatomic) int yearShowing;
@property (nonatomic) int currentDay;
@property (nonatomic) int currentMonth;
@property (nonatomic) int currentYear;
@property (nonatomic, strong) MTEconsultorio *consul;
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) NSMutableArray *citas;

- (void)fillDaysArray;
-(void)cargarCitas;

@end
