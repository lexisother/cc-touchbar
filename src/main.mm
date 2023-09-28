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
}

NODE_MODULE(NODE_GYP_MODULE_NAME, Initialize)
