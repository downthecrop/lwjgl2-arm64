/* 
 * Copyright (c) 2002-2012 LWJGL Project
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are 
 * met:
 * 
 * * Redistributions of source code must retain the above copyright 
 *   notice, this list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 *
 * * Neither the name of 'LWJGL' nor the names of 
 *   its contributors may be used to endorse or promote products derived 
 *   from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * $Id: org_lwjgl_opengl_MacOSXNativeKeyboard.m 3055 2012-08-29 0:46:00Z mojang $
 *
 * Mac OS X native keyboard functions.
 *
 * @author mojang
 * @version $Revision: 3055 $
 */

#import <AppKit/NSApplication.h>
#import <Cocoa/Cocoa.h>
#import <jni.h>
#import <unistd.h>
#import "common_tools.h"
#import "org_lwjgl_opengl_MacOSXNativeMouse.h"
#import "context.h"

JNIEXPORT void JNICALL Java_org_lwjgl_opengl_MacOSXNativeMouse_nGrabMouse(JNIEnv *env, jclass this, jboolean grab) {
	CGAssociateMouseAndMouseCursorPosition(grab == JNI_TRUE ? FALSE : TRUE);
	if (grab)
		CGDisplayHideCursor(kCGDirectMainDisplay);
	else
		CGDisplayShowCursor(kCGDirectMainDisplay);
}

JNIEXPORT void JNICALL Java_org_lwjgl_opengl_MacOSXNativeMouse_nSetCursorPosition(JNIEnv *env, jclass this, jobject window_handle, jint x, jint y) {
	MacOSXWindowInfo *window_info = (MacOSXWindowInfo *)(*env)->GetDirectBufferAddress(env, window_handle);
    
	CGPoint p;
	
	if (window_info->fullscreen) {
		NSSize screenSize = [[NSScreen mainScreen] frame].size;
		NSSize displaySize = window_info->display_rect.size;
		
		p.x = (screenSize.width / displaySize.width) * x;
		p.y = (screenSize.height / displaySize.height) * y;
	}
	else {
		NSPoint point = NSMakePoint(x, y);
		
		p.x = point.x;
		p.y = point.y;
	}
	
	CGWarpMouseCursorPosition(p);
}

JNIEXPORT void JNICALL Java_org_lwjgl_opengl_MacOSXNativeMouse_nRegisterMouseListener(JNIEnv *env, jobject _this, jobject window_handle) {
	MacOSXWindowInfo *window_info = (MacOSXWindowInfo *)(*env)->GetDirectBufferAddress(env, window_handle);
    [window_info->window setAcceptsMouseMovedEvents:YES];
    window_info->jmouse = (*env)->NewGlobalRef(env, _this);
}

JNIEXPORT void JNICALL Java_org_lwjgl_opengl_MacOSXNativeMouse_nUnregisterMouseListener(JNIEnv *env, jobject this, jobject window_handle) {
	MacOSXWindowInfo *window_info = (MacOSXWindowInfo *)(*env)->GetDirectBufferAddress(env, window_handle);
    [window_info->window setAcceptsMouseMovedEvents:NO];
    window_info->jmouse = nil;
}
