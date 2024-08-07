#include "touchbar.mm"
#include <Cocoa/Cocoa.h>
#include <node.h>

using v8::Exception;
using v8::FunctionCallbackInfo;
using v8::Isolate;
using v8::Local;
using v8::Object;
using v8::String;
using v8::Value;

NSWindow *GetWindow(Isolate *isolate) {
  NSWindow *window = [NSApplication sharedApplication].windows[0];
  if (!window) {
    isolate->ThrowException(Exception::ReferenceError(
        String::NewFromUtf8(isolate, "No window found. Aborting.")
            .ToLocalChecked()));
    throw "no window";
  }
  return window;
}

CCTouchBarDelegate *g_TouchBarDelegate = NULL;
void SetTouchbar(const FunctionCallbackInfo<Value> &args) {
  Isolate *isolate = args.GetIsolate();

  if (!g_TouchBarDelegate) {
    g_TouchBarDelegate = [[CCTouchBarDelegate alloc] init];

    /* NOTE: After getting the mod running on NodeJS v22.2.0 under macOS Sonoma
       14.5, this line of code is causing the following error:
        Terminating app due to uncaught exception
        'NSInternalInconsistencyException', reason: 'API misuse: modification of
        a menu's items on a non-main thread when the menu is part of the main
        menu. Main menu contents may only be modified from the main thread.'
      
      Commenting it fixes it. Reading the docs about this property makes me
      wonder why this was even set to YES in the first place.

      To read about this property, see:
      <https://developer.apple.com/documentation/appkit/nsapplication/2646923-automaticcustomizetouchbarmenuit/>
    */
    // [NSApplication sharedApplication]
    //     .automaticCustomizeTouchBarMenuItemEnabled = YES;
  }

  NSWindow *window;
  try {
    window = GetWindow(isolate);
  } catch (char const *e) {
    return;
  }

  // Get our touch bar instance
  NSTouchBar *touchBar = [g_TouchBarDelegate makeTouchBar];

  NSLog(@"[CCTouchBar] Operating on window: %@", window.title);

  // Set the window's touchbar to our custom touchbar
  [window setTouchBar:touchBar];
}

void SetButtonLabel(const FunctionCallbackInfo<Value> &args) {
  // Setup
  Isolate *isolate = args.GetIsolate();
  String::Utf8Value s(isolate, args[0]);
  std::string str(*s);

  NSWindow *window;
  try {
    window = GetWindow(isolate);
  } catch (char const *e) {
    return;
  }

  // Get our button instance and change its label.
  NSButton *button =
      [window.touchBar itemForIdentifier:@"dev.alyxia.cctouchbar"].view;
  NSString *label = [NSString stringWithFormat:@"%s", str.c_str()];
  NSLog(@"[CCTouchBar#SetButtonLabel] '%@' -> '%@'", button.title, label);
  button.title = label;

  // Mark the button as requiring a redraw.
  // <https://developer.apple.com/documentation/appkit/nsview/1483360-needsdisplay/>
  button.needsDisplay = true;
}

void Method(const FunctionCallbackInfo<Value> &args) {
  Isolate *isolate = args.GetIsolate();
  args.GetReturnValue().Set(
      String::NewFromUtf8(isolate, "world").ToLocalChecked());
}

void Initialize(Local<Object> exports) {
  NSLog(@"[CCTouchBar] Initializing");

  NSLog(@"[CCTouchBar] Registering module exports");
  NODE_SET_METHOD(exports, "hello", Method);
  NODE_SET_METHOD(exports, "setTouchbar", SetTouchbar);
  NODE_SET_METHOD(exports, "setButtonLabel", SetButtonLabel);
}

NODE_MODULE(NODE_GYP_MODULE_NAME, Initialize)
