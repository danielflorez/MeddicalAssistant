//
//  MTEEntidad.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 10/21/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTEEntidad : NSObject
@property (nonatomic, strong) NSString *idEnt;
@property (nonatomic, strong) NSString *codigo;
@property (nonatomic, strong) NSString *nombre;
@property (nonatomic, strong) NSString *idMedico;
@property BOOL check;

@end
