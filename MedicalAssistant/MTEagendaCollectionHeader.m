//
//  MTEagendaCollectionHeader.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 9/3/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEagendaCollectionHeader.h"

@implementation MTEagendaCollectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)prevMonthClick:(id)sender {
    self.amvc.monthShowing --;
    if (self.amvc.monthShowing < 1) {
        self.amvc.monthShowing = 12;
        self.amvc.yearShowing --;
    }
    [self.amvc fillDaysArray];
    [self.amvc cargarCitas];
}

- (IBAction)nextMonthClick:(id)sender {
    self.amvc.monthShowing++;
    if (self.amvc.monthShowing > 12) {
        self.amvc.monthShowing = 1;
        self.amvc.yearShowing ++;
    }
    [self.amvc fillDaysArray];
    [self.amvc cargarCitas];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
