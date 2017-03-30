//
//  MTESelecEntidadTableViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 10/23/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEEntidad.h"
#import "MTECrearClienteViewController.h"

@interface MTESelecEntidadTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *entidades;
@property (nonatomic, weak) MTECrearClienteViewController *ccvc;
@property (nonatomic, strong) NSString *memberID;

@end
