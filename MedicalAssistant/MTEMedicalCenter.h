//
//  MTEMedicalCenter.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 10/16/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTEpaciente.h"
#import "MTEconsultorio.h"
#import "MTEEntidad.h"
#import "MTEprocedimiento.h"
#import "MTEprecioProcedimiento.h"
#import "MTEConsultoriosTableViewController.h"
#import "MTEiPadConsultoriosTableViewController.h"

@interface MTEMedicalCenter : NSObject
@property (nonatomic, strong) NSMutableArray *pacientes;
@property (nonatomic, strong) NSMutableArray *consultorios;
@property (nonatomic, strong) NSMutableArray *entidades;
@property (nonatomic, strong) NSMutableArray *procedimientos;
@property (nonatomic, strong) NSMutableArray *preciosProcedimientos;
@property (nonatomic, strong) NSMutableArray *diagnosticos;
@property (nonatomic, strong) NSMutableArray *medicamentos;
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) MTEConsultoriosTableViewController *ctvc;
@property (nonatomic, strong) MTEiPadConsultoriosTableViewController *ictvc;
@property (nonatomic, strong) NSString *servicesAddres;

+ (MTEMedicalCenter *)sharedCenter;
- (void)loadData;
- (void)addPaciente:(MTEpaciente *)paciente;
- (void)addConsultorio:(MTEconsultorio *)consultorio;
- (void)loadPacientes;
- (void)loadConsultorios:(MTEConsultoriosTableViewController *) ctvc;
- (void)loadiPadConsultorios:(MTEiPadConsultoriosTableViewController *) ctvc;
- (void)loadPreciosProcedimientosSolo;
- (void)loadDiagnosticos;
- (void)loadMedicamentos;

@end
