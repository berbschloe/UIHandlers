# UIHandlers
Adds closure support to UIControls and UIViews with UIGestureRecognizers.

## Requirements

- iOS 9.0+
- Xcode 10.2+
- Swift 5.0+

## Instalation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate the library into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'UIHandlers', '1.4.0'
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

```swift
dependencies: [
    .package(url: "https://github.com/berbschloe/UIHandlers.git", from: "1.4.0")
]
```

## Usage

#### Importing
It would be recommended to add the library globally because it can get annoying importing it everywhere.

```swift
// Add this to a GlobalImports.swift
@_exported import UIHandlers
```

### Adding Event Handlers to Controls

#### Normal way of Listening to Control Events

```swift
func viewDidLoad() {
    super.viewDidLoad()
    
    let button = UIButton()
    
    button.addTarget(self, action: #selector(doSomething), for: .primaryActionTriggered)
}

@objc
private func doSomething() { ... }
```

#### Adding a Handler to Control Instead

```swift
func viewDidLoad() {
    super.viewDidLoad()
    
    let button = UIButton()

    // [unowned self] is needed to prevent reference cycles
    button.addHandler(for: .primaryActionTriggered) { [unowned self] in
        self.doSomething();
    }
}
```

#### Adding a Handler with Multiple Paramaters

```swift
button.addHandler(for: .primaryActionTriggered) { ... }
button.addHandler(for: .primaryActionTriggered) ( (sender: UIButton) in ... }
button.addHandler(for: .primaryActionTriggered) ( (sender: UIButton, event: UIEvent) in ... }
```
### Adding Handlers for Gesture Recognizers to a View

#### Normal way of Adding Gesture Recognizer to a View

```swift
func viewDidLoad() {
    super.viewDidLoad()
    
    let view = UIView()

    let gesture = UITapGestureRecognizer(target: self, action: #selector(doSomething))
    view.addGestureRecognizer(gesture)
}

@objc
private func doSomething() { ... }
```

#### Adding a Tap Gesture Recognizer to a View

```swift
func viewDidLoad() {
    super.viewDidLoad()
    
    let view = UIView()
    
    view.addTapHandler() { [unowned self] in
        self.doSomething()
    }
}
```

#### More Variants of Adding a Tap Gesture

```swift
// tap handler with paramater
view.addTapHandler() { (gesture: UITapGestureRecognizer) in ... }

// controling the number of taps
view.addTapHandler(numberOfTapsRequired: 42) { ... }
```

#### Other Suported Gesture Recognizers

```swift
view.addDoubleTapHandler() { ... }
view.addLongPressHandler() { ... }
view.addPanHandler() { ... }
view.addSwipeHandler(direction: .right) { ... }
view.addPinchHandler() { ... }
view.addRotationHandler() { ... }
view.addScreenEdgePanHandler(edges: .right) { ... } 
```
