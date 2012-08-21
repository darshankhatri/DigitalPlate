//
//  RestaurantSelector.m
//  DigitalPlate
//
//  Created by iDroid on 18/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "RestaurantSelector.h"
#import "Restaurant.h"

@implementation RestaurantSelector

@synthesize  caller, context, data;

-(id)initWithCaller:(id)_caller data:(NSArray*)_data title:(NSString*)_title andContext:(id)_context{
    
    NSMutableString *messageString = [NSMutableString stringWithString:@"\n"];
    tableHeight = 0;
    if([_data count] < 6){
        for(int i = 0; i < [_data count]; i++){
            [messageString appendString:@"\n\n"];
            tableHeight += 53;
        }
    }else{
            [messageString appendString:@"\n\n\n\n\n\n\n\n\n"];
            tableHeight = 207;
    }
    	     
    if(self = [super initWithTitle:_title message:messageString delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil]){
        self.caller = _caller;
        self.context = _context;
        self.data = _data;
        [self prepare];
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.caller didSelectRowAtIndex:-1 withContext:self.context];
}

-(void)show{
    self.hidden = YES;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myTimer:) userInfo:nil repeats:NO];
    [super show];
}

-(void)myTimer:(NSTimer*)_timer{
    self.hidden = NO;
    [myTableView flashScrollIndicators];
}

-(void)prepare{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(11, 50, 261, tableHeight) style:UITableViewStylePlain];
    if([data count] < 5){
        myTableView.scrollEnabled = NO;
    }
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self addSubview:myTableView];
	     
    UIImageView *imgView = [[[UIImageView alloc] initWithFrame:CGRectMake(11, 50, 261, 4)] autorelease];
    imgView.image = [UIImage imageNamed:@"top.png"];
    [self addSubview:imgView];
	     
    imgView = [[[UIImageView alloc] initWithFrame:CGRectMake(11, tableHeight+46, 261, 4)] autorelease];
    imgView.image = [UIImage imageNamed:@"bottom.png"];
    [self addSubview:imgView];
	     
    CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 10);
    [self setTransform:myTransform];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"alertcell"];
    if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:@"alertcell"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;        
    }
    Restaurant *restaurant = (Restaurant *)[data objectAtIndex:indexPath.row];
    [cell.textLabel setText:restaurant.resturantName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissWithClickedButtonIndex:0 animated:YES];
    [self.caller didSelectRowAtIndex:indexPath.row withContext:self.context];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

-(void)dealloc{
    self.data = nil;
    self.caller = nil;
    self.context = nil;
    [myTableView release];
    [super dealloc];
}

@end
