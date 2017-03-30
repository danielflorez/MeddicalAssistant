//
//  MTECrearCitaViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 10/30/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEpaciente.h"
#import "MTEprocedimiento.h"
#import "MTEconsultorio.h"
#import "MTEAgendaDayTableViewController.h"
#import "MTEcita.h"

@interface MTECrearCitaViewController : UIViewController
@property (nonatomic, strong) NSDate *day;
@property (nonatomic, strong) MTEpaciente *pac;
@property (nonatomic, strong) MTEprocedimiento *proc;
@property (nonatomic, strong) MTEconsultorio *consul;
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) MTEAgendaDayTableViewController *adtvc;
@property (nonatomic, strong) MTEcita *cita;
@property (nonatomic, strong) NSIndexPath *index;
@property int crear;

@end
