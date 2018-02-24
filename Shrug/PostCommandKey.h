#ifndef PostCommandKey_h
#define PostCommandKey_h

#import <AppKit/AppKit.h>

#define KEY_CODE_V ((CGKeyCode)9)

void DCPostCommandAndKey(CGKeyCode key)
{
    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
    
    CGEventRef keyDown = CGEventCreateKeyboardEvent(source, key, TRUE);
    CGEventSetFlags(keyDown, kCGEventFlagMaskCommand);
    CGEventRef keyUp = CGEventCreateKeyboardEvent(source, key, FALSE);
    
    CGEventPost(kCGAnnotatedSessionEventTap, keyDown);
    CGEventPost(kCGAnnotatedSessionEventTap, keyUp);
    
    CFRelease(keyUp);
    CFRelease(keyDown);
    CFRelease(source);
}

#endif /* PostCommandKey_h */
