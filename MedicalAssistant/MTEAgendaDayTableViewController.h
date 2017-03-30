//
//  MTEAgendaDayTableViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 9/4/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEday.h"
#import "MTEconsultorio.h"
#import "MTEcita.h"
#import "MTEiphoneAgendaMonthCollectionViewController.h"

@interface MTEAgendaDayTableViewController : UITableViewController
@property (nonatomic, strong) MTEday *day;
@property (nonatomic, strong) NSMutableArray *hours;
@property (nonatomic, strong) MTEconsultorio *consul;
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) NSMutableArray *citas;
@property (nonatomic, strong) MTEiphoneAgendaMonthCollectionViewController *iamvc;

-(void)addCita:(MTEcita *)cita;
-(void)updateCita:(MTEcita *)cita;

@end
