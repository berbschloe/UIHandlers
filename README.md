# UIHandlers
Adds closure support to UIControls and UIViews with UIGestureRecognizers.

## Requirements

- iOS 9.0+
- Xcode 10.2+
- Swift 5.0+

## Instalation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Alamofire into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'UIHandlers', '1.3.0'
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

```swift
dependencies: [
    .package(url: "https://github.com/berbschloe/UIHandlers.git", from: "1.3.0")
]
```

## Usage

### Importing
It would be recommended to add UIHandlers globally because it can get annoying importing it everywhere.

```swift
// Add this to a GlobalImports.swift
@_exported import UIHandlers
```

### Normal way of listening to UIControl Events

```swift
func viewDidLoad() {
    super.viewDidLoad()
    
    let button = UIButton()
    
    button.addTarget(self, action: #selector(doSomething), for: .primaryActionTriggered)
}

@objc
private func doSomething() { ... }

```

### Adding a handler to UIControl instead

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
