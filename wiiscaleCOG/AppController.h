#import <Cocoa/Cocoa.h>

//#import "PrefsController.h"
//#import "Socket.h"
#import "MyObject.h"
#import "WiiRemote.h"
#import "WiiRemoteDiscovery.h"
#import "MyOpenGLView.h"
//#import "racketOpenGL.h"
#import "FPLevelIndicator.h"
//#import <Python/Python.h>
#import "WiiScale-Swift.h"

@interface AppController : NSWindowController<WiiRemoteDelegate, WiiRemoteDiscoveryDelegate> {
    
	IBOutlet NSTextField* weight;
	IBOutlet NSTextField* status;
	IBOutlet NSTextField* bbstatus;
	IBOutlet FPLevelIndicator* weightIndicator;
	IBOutlet NSMenuItem* fileConnect;
	IBOutlet NSMenuItem* fileTare;
	//IBOutlet NSWindow* prefs;
    IBOutlet MyOpenGLView* openglWin;
	//IBOutlet PrefsController *prefsController;
    IBOutlet NSButton* btn;

	WiiRemoteDiscovery* discovery;
	WiiRemote* wii;
    //WiiScaleSocket* wiisocket;
    SocketIOClient* socket;
	
	float tare;
	float avgWeight;
	float sentWeight;
	float lastWeight;
	float weightSamples[100];
	int weightSampleIndex;
	BOOL sent;
	float height_cm;
    float cogX;
    float cogY;
    //@public
    float weightTR;
    float weightBR;
    float weightTL;
    float weightBL;
}

//- (void) testSocket;
- (IBAction)doDiscovery:(id)sender;
- (IBAction)doTare:(id)sender;
- (IBAction)send:(id)sender;
//- (void)registerAsObserver;

@end