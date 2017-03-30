//
//  MTEiPadCrearCitaViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 11/18/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEpaciente.h"
#import "MTEprocedimiento.h"
#import "MTEconsultorio.h"
#import "MTEcita.h"
#import "MTEiPadDayAgendaTableViewController.h"

@interface MTEiPadCrearCitaViewController : UIViewController
@property (nonatomic, strong) NSDate *day;
@property (nonatomic, strong) MTEpaciente *pac;
@property (nonatomic, strong) MTEprocedimiento *proc;
@property (nonatomic, strong) MTEconsultorio *consul;
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) MTEiPadDayAgendaTableViewController *adtvc;
@property (nonatomic, strong) MTEcita *cita;
@property (nonatomic, strong) NSIndexPath *index;
@property int crear;

@end
