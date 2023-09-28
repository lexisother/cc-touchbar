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
    [NSApplication sharedApplication]
        .automaticCustomizeTouchBarMenuItemEnabled = YES;
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

  NSLog(@"[CCTouchBar#SetButtonLabel] Received: %s", str.c_str());

  NSWindow *window;
  try {
    window = GetWindow(isolate);
  } catch (char const *e) {
    return;
  }

  // Lord forgive what I'm about to do.
  NSTouchBar *touchBar = window.touchBar;
  NSTouchBarItem *item = [touchBar itemForIdentifier:@"dev.alyxia.cctouchbar"];
  NSButton *button = item.view;
  NSLog(@"[CCTouchBar#SetButtonLabel] Current button title: %@", button.title);
  NSString *label = [NSString stringWithFormat:@"%s", str.c_str()];
  NSLog(@"[CCTouchBar#SetButtonLabel] Converted to NSString: %@", label);
  button.title = label;
  [button setTitle:label];
  NSLog(@"[CCTouchBar#SetButtonLabel] After set button title: %@",
        button.title);

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
