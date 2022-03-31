#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>

HBPreferences *preferences;

@protocol WFCloudKitItem
@end

@protocol WFLoggableObject
@end

@protocol WFNaming
@end

@interface WFRecord : NSObject <NSCopying>
@end

@interface WFWorkflowRecord : WFRecord <WFNaming>
@property (copy, nonatomic) NSArray *actions; // ivar: _actions
@property (copy, nonatomic) NSString *minimumClientVersion; // ivar: _minimumClientVersion
@end

@interface WFSharedShortcut : NSObject <WFCloudKitItem, WFLoggableObject>
@property (retain, nonatomic) WFWorkflowRecord *workflowRecord; // ivar: _workflowRecord
-(id)workflowRecord;
@end

%hook WFSharedShortcut
-(id)workflowRecord {
    //NSLog(@"Pastcuts HOOKING WFSharedShortcut!");
    id rettype = %orig;
    [rettype setMinimumClientVersion:@"1"];
    id rettypeactions = [rettype actions];
    //NSLog(@"Pastcuts Actions by WFSharedShortcutshare: %@", [rettype actions]);
    NSArray *origShortcutActions = rettypeactions;
    NSArray *newShortcutActions = rettypeactions;
    NSMutableArray *newMutableShortcutActions = [newShortcutActions mutableCopy];
    int shortcutActionsObjectIndex = 0;
    
    for (id shortcutActionsObject in origShortcutActions) {
        //NSLog(@"Pastcuts Array Item in %i: %@",shortcutActionsObjectIndex,shortcutActionsObject);
        if ([shortcutActionsObject isKindOfClass:[NSDictionary class]]){
            //NSLog(@"Pastcuts item is NSDictionary!");
            if ([shortcutActionsObject objectForKey:@"WFWorkflowActionIdentifier"]) {
            if ([[shortcutActionsObject valueForKey:@"WFWorkflowActionIdentifier"] isEqual:@"is.workflow.actions.returntohomescreen"]) {
	//in iOS 15, there's a native return to homescreen action. pre-iOS 15 you could use open app for SpringBoard instead, so we're doing that
            NSMutableDictionary *mutableShortcutActionsObject = [shortcutActionsObject mutableCopy];
    
            [mutableShortcutActionsObject setValue:@"is.workflow.actions.openapp" forKey:@"WFWorkflowActionIdentifier"];
            NSDictionary *actionparameters = [[NSDictionary alloc] initWithObjectsAndKeys:@"com.apple.springboard", @"WFAppIdentifier", nil];
            [mutableShortcutActionsObject setValue:actionparameters forKey:@"WFWorkflowActionParameters"];
    
            NSDictionary *newShortDict = [[NSDictionary alloc] initWithDictionary:mutableShortcutActionsObject];
            newMutableShortcutActions[shortcutActionsObjectIndex] = newShortDict;
            } else if ([[shortcutActionsObject valueForKey:@"WFWorkflowActionIdentifier"] isEqual:@"is.workflow.actions.output"]) {
            NSMutableDictionary *mutableShortcutActionsObject = [shortcutActionsObject mutableCopy];

            [mutableShortcutActionsObject setValue:@"is.workflow.actions.exit" forKey:@"WFWorkflowActionIdentifier"];
            if ([[[[[mutableShortcutActionsObject valueForKey:@"WFWorkflowActionParameters"] valueForKey:@"WFOutput"] valueForKey:@"Value"] valueForKey:@"attachmentsByRange"] valueForKey:@"{0, 1}"]) {
	//in iOS 15, if an Exit action has output it's converted into the Output action, so we convert it back

            NSDictionary *actionParametersWFResult = [[NSDictionary alloc] initWithObjectsAndKeys:@"placeholder", @"Value", @"WFTextTokenAttachment", @"WFSerializationType", nil];
            NSMutableDictionary *mutableActionParametersWFResult = [actionParametersWFResult mutableCopy];
            [mutableActionParametersWFResult setValue:[[[[[mutableShortcutActionsObject valueForKey:@"WFWorkflowActionParameters"] valueForKey:@"WFOutput"] valueForKey:@"Value"] valueForKey:@"attachmentsByRange"] valueForKey:@"{0, 1}"] forKey:@"Value"];
            NSDictionary *actionParameters = [[NSDictionary alloc] initWithObjectsAndKeys:@"placeholder", @"WFResult", nil];
            NSMutableDictionary *mutableActionParameters = [actionParameters mutableCopy];
            [mutableActionParameters setValue:mutableActionParametersWFResult forKey:@"WFResult"];
            [mutableShortcutActionsObject setValue:mutableActionParameters forKey:@"WFWorkflowActionParameters"];
            } else {
                // NSLog(@"Detected Output action but no valid action parameters for conversion");
            }
            NSDictionary *newShortDict = [[NSDictionary alloc] initWithDictionary:mutableShortcutActionsObject];
            newMutableShortcutActions[shortcutActionsObjectIndex] = newShortDict;
            } else if ([[shortcutActionsObject valueForKey:@"WFWorkflowActionIdentifier"] isEqual:@"is.workflow.actions.file.select"]) {
	//in iOS 15, Get File with WFShowFilePicker is turned into Select File, so we convert it back
            NSMutableDictionary *mutableShortcutActionsObject = [shortcutActionsObject mutableCopy];

            [mutableShortcutActionsObject setValue:@"is.workflow.actions.documentpicker.open" forKey:@"WFWorkflowActionIdentifier"];
            NSMutableDictionary *mutableActionParameters = [[mutableShortcutActionsObject valueForKey:@"WFWorkflowActionParameters"] mutableCopy];
            BOOL yesvalue = YES;
            [mutableActionParameters setValue:[NSNumber numberWithBool:yesvalue] forKey:@"WFShowFilePicker"];
            [mutableShortcutActionsObject setValue:mutableActionParameters forKey:@"WFWorkflowActionParameters"];

            NSDictionary *newShortDict = [[NSDictionary alloc] initWithDictionary:mutableShortcutActionsObject];
            newMutableShortcutActions[shortcutActionsObjectIndex] = newShortDict;
            } else if ([[shortcutActionsObject valueForKey:@"WFWorkflowActionIdentifier"] isEqual:@"is.workflow.actions.documentpicker.open"] && [[shortcutActionsObject valueForKey:@"WFWorkflowActionParameters"] valueForKey:@"WFGetFilePath"] && (!([[shortcutActionsObject valueForKey:@"WFWorkflowActionParameters"] valueForKey:@"WFShowFilePicker"]))) {
	//in iOS 15, a new Get File action doesn't initially use WFShowFilePicker, so if WFGetFilePath is there and WFShowFilePicker we set it to false
                //NSLog(@"Pastcuts Setting WFShowFilePicker to false...");
            NSMutableDictionary *mutableShortcutActionsObject = [shortcutActionsObject mutableCopy];

            NSMutableDictionary *mutableActionParameters = [[mutableShortcutActionsObject valueForKey:@"WFWorkflowActionParameters"] mutableCopy];
            BOOL novalue = NO;
            //NSLog(@"Pastcuts Setting no value to parameters...");
            [mutableActionParameters setObject:[NSNumber numberWithBool:novalue] forKey:@"WFShowFilePicker"];
            //NSLog(@"Pastcuts Updating new parameters to new action object...");
            //NSLog(@"Pastcuts Our new parameters are: %@",mutableActionParameters);
            [mutableShortcutActionsObject setObject:mutableActionParameters forKey:@"WFWorkflowActionParameters"];
            //NSLog(@"Pastcuts Updated New action object with modified parameters!");
            //NSLog(@"Pastcuts Our new action with fixed params is: %@",mutableShortcutActionsObject);

            NSDictionary *newShortDict = [[NSDictionary alloc] initWithDictionary:mutableShortcutActionsObject];
            newMutableShortcutActions[shortcutActionsObjectIndex] = newShortDict;
            }
            }
        }
        //NSLog(@"Type: %@",[shortcutActionsObject class]);
        shortcutActionsObjectIndex++;
    }
    
    shortcutActionsObjectIndex = 0;

    //NSLog(@"Pastcuts Our new actions mutable array is %@",newMutableShortcutActions);
    rettypeactions = [[NSArray alloc] initWithArray:newMutableShortcutActions];
    [rettype setActions:newMutableShortcutActions];
    //NSLog(@"Pastcuts Finished analyzation of workflowRecord!");
    return rettype;
}
%end

%hook WFDevice
-(id)systemVersion {
    if ([preferences boolForKey:@"isEnableVersionSpoofing"]) {
	if (!([preferences objectForKey:@"versionToSpoof"])){
	    return @"15.4";
	} else {
	    return [preferences objectForKey:@"versionToSpoof"];
	}
    } else {
        return [[UIDevice currentDevice] systemVersion];
    }
}
%end

%ctor {
  preferences = [[HBPreferences alloc] initWithIdentifier:@"com.zachary7829.pastcutsprefs"];
}
