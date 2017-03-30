//
//  MTEcitaCompleta.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 11/17/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTEcita.h"

@interface MTEcitaCompleta : NSObject
@property (nonatomic, strong) MTEcita *cita;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *dateFin;

@end
