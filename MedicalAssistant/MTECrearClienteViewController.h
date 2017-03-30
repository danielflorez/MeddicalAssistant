//
//  MTECrearClienteViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 10/23/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEpaciente.h"
#import "MTEClientesTableViewController.h"
#import "MTEEntidad.h"


@interface MTECrearClienteViewController : UIViewController

@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) MTEClientesTableViewController *ctvc;
@property (nonatomic, strong) MTEEntidad *entSeleccionada;
@property (nonatomic, strong) MTEpaciente *paci;
@property (nonatomic, strong) NSIndexPath *index;
@property int crear;
@property int selec;

@end
