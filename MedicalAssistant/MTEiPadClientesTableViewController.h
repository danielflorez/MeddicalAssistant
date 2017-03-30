//
//  MTEiPadClientesTableViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 10/27/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEiPadCrearCitaViewController.h"

@interface MTEiPadClientesTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>
@property (nonatomic, strong) NSMutableArray *pacientes;
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) NSMutableArray *filteredPacientesArray;
@property (nonatomic, strong) MTEiPadCrearCitaViewController *ccvc;

@property bool cita;

- (void) reloadData;

@end
