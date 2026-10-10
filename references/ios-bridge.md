# Swift at the Flutter iOS boundary

Abdullah AlMunaikh’s scoped native companion. This guide is for iOS plugins and integrations owned by a Flutter app.

## Establish the actual embedding

Inspect `ios/`, plugin pod/package configuration, the selected Xcode toolchain, deployment target, Flutter SDK, and the existing registrar. Do not invent a universal AppDelegate template: registration and engine lifecycle can differ. Reuse the project’s platform channel or generated Pigeon contract when present.

Use a method channel for request/response, an event channel for a stream whose listener lifecycle is owned, and a platform view only when a native view is actually necessary. Prefer an established plugin for system pickers and permissions when it satisfies the capability. A Flutter Cupertino widget is not a UIKit object.

## A narrow method channel

This complete Swift plugin illustrates a codec-compatible system-information response. Register it through the project’s existing plugin registration. It reads UIKit on the main queue and maps unknown methods to the framework sentinel.

```swift
import Flutter
import UIKit

public final class MobileInfoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "mobile_info",
      binaryMessenger: registrar.messenger()
    )
    registrar.addMethodCallDelegate(MobileInfoPlugin(), channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "systemVersion" else {
      result(FlutterMethodNotImplemented)
      return
    }
    DispatchQueue.main.async {
      result(UIDevice.current.systemVersion)
    }
  }
}
```

Reply exactly once on every path; an unresumed result hangs Dart. A stream uses sink events and an explicit cancellation handler, not repeated method replies. Match method names, nullability, schema, and codec types on both sides. Convert dates, bytes, enums, and errors deliberately; custom Swift structs do not cross a standard codec automatically.

For larger APIs, a generated typed bridge can remove stringly typed contracts. Inspect the project’s pinned Pigeon generator and resulting files rather than hand-writing generated code. Validate malformed arguments with a stable `FlutterError` code, safe message, and codec-compatible details.

## Swift data and concurrency

Default to structs/enums for payloads, `let` for stable values, and classes where identity or resource ownership matters. Use enums with associated values for native operation state; bridge them through explicit codecs. Keep implementation private and APIs clear at the Dart call site.

Respect actual actor isolation and toolchain settings. UIKit work belongs on the main thread/actor; `async` is not a guarantee of background CPU execution. Use structured operations where possible, and retain/cancel tasks whose lifetime is tied to a plugin, stream listener, scene, or view. Cancellation is cooperative. Re-check operation identity and state after await; actor isolation does not make a multi-await operation a transaction.

Do not suppress concurrency diagnostics with unchecked sendability or assumed isolation without proving the synchronization contract. Do not change project-wide isolation settings to clear one plugin warning. Offload measured expensive work through supported APIs and return only safe transferable values; profile with Instruments when native work causes a hang.

## Lifetime, streams, and views

Avoid retain cycles among task closures, delegates, channels, and platform views. Weak references are for actual ownership cycles, with explicit behavior when the owner is gone. Cancel work and unregister native observations at the owned lifecycle boundary. Remove event sinks on cancel; ignore late native callbacks from canceled generations. Detaching an engine is not successful completion.

For platform views, define accessibility labels/actions, focus behavior, gesture participation, safe-area/keyboard ownership, and disposal. Test contention with Flutter scroll and back gestures. A view that looks right but traps VoiceOver or steals every drag is incomplete.

Request only necessary permission when the feature needs it; preserve denied/restricted states in Dart UI and supply retry/settings behavior where appropriate. Haptics are optional supplemental feedback. Respect system preferences and availability checks for device APIs.

## Validation

Dart: channel contract, expected value/error, cancellation, stale responses, and stream unsubscribe through a test binary messenger. Swift: native unit tests for transformation/state and platform integration tests for registration, thread/actor requirements, and callback lifecycle. Build against the project’s actual Flutter module and iOS targets. A standalone `swiftc` invocation without the Flutter module is not evidence of plugin compatibility.

Sources: [Flutter platform channels](https://docs.flutter.dev/platform-integration/platform-channels), [Flutter platform views](https://docs.flutter.dev/platform-integration/ios/platform-views), [Swift documentation](https://www.swift.org/documentation/).
