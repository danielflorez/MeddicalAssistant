//
//  MTEiPadAgendaViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 9/5/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEday.h"
#import "MTEconsultorio.h"
#import "MTEcita.h"


@interface MTEiPadAgendaViewController : UIViewController
@property (nonatomic, strong) MTEconsultorio *consul;
@property (nonatomic, strong) NSString *memberID;

- (void)selectedDateChanged:(MTEday *)day;
- (void)disableInteraction;
- (void)enableInteraction;
- (void)citasChanged;
-(void)updateCita:(MTEcita *)cita;
-(void)addCita:(MTEcita *)cita;


@end
