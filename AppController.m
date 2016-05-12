#import "AppController.h"

@implementation AppController
#pragma mark Window

- (id)init
{
    self = [super init];
    if (self) {
        serverConnected = NO;
		weightSampleIndex = 0;
        
        // Load TextStrings.plist
        //NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"TextStrings" ofType:@"plist"];
        //strings = [[NSDictionary dictionaryWithContentsOfFile:plistPath] copy];
		
		if(!discovery) {
			[self performSelector:@selector(doDiscovery:) withObject:self afterDelay:0.0f];
		}
        //NSLog(@"initializeABE");
        //[self registerAsObserver];
        //[self testSocket];
        //wiisocket = [[WiiScaleSocket alloc] init];
        //NSURL* url = [[NSURL alloc] initWithString:@"http://ailab-mayfestival2016-server.herokuapp.com"];
        NSURL* url = [[NSURL alloc] initWithString:@"http://192.168.1.39:8000"];
        
        socket = [[SocketIOClient alloc] initWithSocketURL:url options:@{@"log": @YES, @"forcePolling": @NO}];
        
        [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"socket connected");
            serverConnected = YES;
            [socket emit:@"enter_room" withItems:@[@{@"room": @"wiifit"}]];
        }];
        
        [socket on:@"disconnect" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"socket disconnected");
            serverConnected = NO;
        }];
        
        [socket on:@"reconnect" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"socket reconnected");
            serverConnected = YES;
            [socket emit:@"enter_room" withItems:@[@{@"room": @"wiifit"}]];
        }];
        
        [socket on:@"currentAmount" callback:^(NSArray* data, SocketAckEmitter* ack) {
            double cur = [[data objectAtIndex:0] floatValue];
            
            //[socket emitWithAck:@"canUpdate" withItems:@[@(cur)]](0, ^(NSArray* data) {
            [socket emit:@"update" withItems:@[@{@"amount": @(cur + 2.50)}]];
            //});
            
            //[ack with:@[@"Got your currentAmount, ", @"dude"]];
            

        }];
        
        _lock = [[NSLock alloc] init];
        tm = [NSTimer scheduledTimerWithTimeInterval:1.0f/6.0f target:self selector:@selector(hoge:) userInfo:nil repeats:YES];
        [socket connect];
        count = 0;

    }
    return self;
}

-(void)hoge:(NSTimer*)timer{
    if (serverConnected){
        //割り込み禁止
        [_lock lock];
        float cogX_ = cogX;
        
        [_lock unlock];
        [socket emit:@"transfer" withItems:@[@{@"event": @"SendCOG",
                                               @"room" : @"Game",
                                               @"data" : @(cogX_)}]];
    }
}

-(IBAction)send:(id)sender{
    NSLog(@"SENDING SOCKET");
    [socket emit:@"from_client" withItems:[NSArray arrayWithObjects:@"Socket from ABE", nil]];
    [socket emit:@"from_client" withItems:[NSArray arrayWithObjects:@"Socket from KEN", nil]];
    NSLog(@"SENDED SOCKET");
}

- (void)dealloc
{
	[super dealloc];
}
// It won't show the weight if you delete this method!!!!!  _ABE_
- (void)awakeFromNib {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(expansionPortChanged:)
												 name:@"WiiRemoteExpansionPortChangedNotification"
											   object:nil];
}
/*
- (void)registerAsObserver{
    [self addObserver:mine forKeyPath:@"weightBL" options:0 context:nil];
    //[self addObserver:mine forKeyPath:@"weightBR" options:NSKeyValueChangeNewKey context:nil];
    //[self addObserver:mine forKeyPath:@"weightTL" options:NSKeyValueChangeNewKey context:nil];
    //[self addObserver:mine forKeyPath:@"weightTR" options:NSKeyValueChangeNewKey context:nil];
    NSLog(@"Added as observer");
}
*/
#pragma mark NSApplication

- (void)applicationWillTerminate:(NSNotification *)notification
{
	[wii closeConnection];
}

#pragma mark Profiles


#pragma mark Wii Balance Board

- (IBAction)doDiscovery:(id)sender {
	
	if(!discovery) {
		discovery = [[WiiRemoteDiscovery alloc] init];
		[discovery setDelegate:self];
		[discovery start];
		
		[bbstatus setStringValue:@"Searching..."];
		[fileConnect setTitle:@"Stop Searching for Balance Board"];
		[status setStringValue:@"Press the red 'sync' button..."];
	} else {
		[discovery stop];
		[discovery release];
		discovery = nil;
		
		if(wii) {
			[wii closeConnection];
			[wii release];
			wii = nil;
		}
		
		[bbstatus setStringValue:@"Disconnected"];
		[fileConnect setTitle:@"Connect to Balance Board"];
		[status setStringValue:@""];
	}
}

- (IBAction)doTare:(id)sender {
	tare = 0.0 - lastWeight;
}

#pragma mark Magic?

- (void)expansionPortChanged:(NSNotification *)nc{

	WiiRemote* tmpWii = (WiiRemote*)[nc object];
	
	// Check that the Wiimote reporting is the one we're connected to.
	if (![[tmpWii address] isEqualToString:[wii address]]){
		return;
	}
	
	if ([wii isExpansionPortAttached]){
		[wii setExpansionPortEnabled:YES];
	}	
}

#pragma mark WiiRemoteDelegate methods

- (void) buttonChanged:(WiiButtonType) type isPressed:(BOOL) isPressed
{	
	[self doTare:self];
}

- (void) wiiRemoteDisconnected:(IOBluetoothDevice*) device
{
	[bbstatus setStringValue:@"Disconnected"];
	
	[device closeConnection];
}

#pragma mark WiiRemoteDelegate methods (optional)

// cooked values from the Balance Beam
- (void) balanceBeamKilogramsChangedTopRight:(float)topRight
                                 bottomRight:(float)bottomRight
                                     topLeft:(float)topLeft
                                  bottomLeft:(float)bottomLeft {
	
	lastWeight = topRight + bottomRight + topLeft + bottomLeft;
	
	if(!tare) {
		[self doTare:self];
	}
	
	float trueWeight = lastWeight + tare;
	[weightIndicator setDoubleValue:trueWeight];
	
    //割り込み禁止
    [_lock lock];
	if(trueWeight > 5.0f) {
        
        cogX = ((topRight + bottomRight) - (topLeft + bottomLeft))/(lastWeight);
        cogY = ((topRight + topLeft) - (bottomRight + bottomLeft))/(lastWeight);
        
        
	} else {
        cogX = 0.0f;
        cogY = 0.0f;
    }
    [_lock unlock];
    [openglWin reWriteX:cogX Y:cogY];
    
    [weight setStringValue:[NSString stringWithFormat:@"%4.1fkg  %4.1flbs", MAX(0.0, trueWeight), MAX(0.0, (trueWeight) * 2.20462262)]];
    
    //[NSThread sleepForTimeInterval:0.5];
    /*
    if (count > 30){
        
        [socket emit:@"transfer" withItems:@[@{@"event": @"SendCOG",
                                               @"room" : @"Game",
                                               @"data" : @(cogX)}]];
        count = 0;
    }
    else{
        count++;
    }
     */
        //[NSArray arrayWithObjects:[NSString stringWithFormat:@"%.4f", cogX], nil]];
    
    //room : Game
    
    //[mine observeValueForKeyPath:@"weightBL" ofObject:self change:NSKeyValueChangeNewKey context:nil];
    
    
    //NSLog(@"\n COG x: %f, y: %f", cogX, cogY);
    
    //NSLog(@"\nTR: %f, TL: %f, BR: %f, BL: %f", topRight, topLeft, bottomRight, bottomLeft);
    
    
}

#pragma mark WiiRemoteDiscoveryDelegate methods

- (void) WiiRemoteDiscovered:(WiiRemote*)wiimote {
	
	[wii release];
	wii = [wiimote retain];
	[wii setDelegate:self];
    

	[bbstatus setStringValue:@"Connected"];
	
	[status setStringValue:@"Tap the button to tare, then step on..."];
}

- (void) WiiRemoteDiscoveryError:(int)code {
	
	NSLog(@"Error: %u", code);
		
	// Keep trying...
	[discovery stop];
	sleep(1);
	[discovery start];
}

- (void) willStartWiimoteConnections {

}

@end
