//
//  UIHandlers
//
//  Copyright (c) 2018 - Present Brandon Erbschloe - https://github.com/berbschloe
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import XCTest
@testable import UIHandlers

class UIHandlersTests: XCTestCase {

    func testActionHandlers() {

        UIControl.swizzle_sendAction() // sendActions() doesn't work in a testing environment

        let button = UIButton()

        let exp1 = expectation(description: "Button Click 1")
        button.addHandler(for: .primaryActionTriggered) { (button: UIButton) in
            exp1.fulfill()
        }

        let exp2 = expectation(description: "Button Click 2")
        button.addHandler(for: .primaryActionTriggered) {
            exp2.fulfill()
        }

        let exp3 = expectation(description: "Button Drag Outsize")
        button.addHandler(for: .touchDragOutside) {
            exp3.fulfill()
        }

        button.addHandler(for: .touchCancel) {
            XCTFail("Should never execute")
        }

        XCTAssertEqual(button.handlers.count, 4)

        button.sendActions(for: [.touchDragOutside, .primaryActionTriggered])

        waitForExpectations(timeout: 0, handler: nil)
    }

    func testGestureRecognizers() {

        let view = UIView()
        var gesture: UITapGestureRecognizer!
        
        _ = autoreleasepool {
            gesture = view.addTapHandler { _ in }
        }

        XCTAssertNotNil(gesture.handler)
    }
    
    func testBarButtonItemClick() {
        
        let exp = expectation(description: "Button Click")
        
        var barButtonItem: UIBarButtonItem?
        
        let handler: ((UIBarButtonItem) -> Void) = {
            XCTAssertEqual(barButtonItem, $0)
            exp.fulfill()
        }
        
        barButtonItem = UIBarButtonItem(barButtonSystemItem: .action, handler: handler)
        
        guard let target = barButtonItem?.target, let action = barButtonItem?.action else {
            XCTFail("Both target and action should not be nil")
            return
        }
        
        _ = target.perform(action, with: barButtonItem)

        waitForExpectations(timeout: 0, handler: nil)
    }
    
    func testHandlerToken() {
        let button = UIButton()
        
        let token = button.addHandler(for: .primaryActionTriggered) {
            XCTFail("Should Never Happen")
        }
        
        XCTAssertEqual(button.handlers.count, 1)
        
        token.cancel()
        
        button.sendActions(for: .primaryActionTriggered)
        
        XCTAssertTrue(button.handlers.isEmpty)
        XCTAssertTrue(button.allTargets.isEmpty)
    }
    
    func testRemovingAllHandlers() {
        let button = UIButton()
        
        button.addHandler(for: .primaryActionTriggered) {
            XCTFail("Should Never Happen")
        }
        
        button.addHandler(for: .touchDown) {
            XCTFail("Should Never Happen")
        }
        
        button.removeAllEventHandlersAndTargets()
        
        button.sendActions(for: .allEvents)
        XCTAssertTrue(button.handlers.isEmpty)
    }
    
    func testBarButtonClearHandler() {
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add) { }
        
        XCTAssertNotNil(barButtonItem.action)
        XCTAssertNotNil(barButtonItem.target)
        XCTAssertNotNil(barButtonItem.handler)
        
        barButtonItem.clearHandler()
        
        XCTAssertNil(barButtonItem.action)
        XCTAssertNil(barButtonItem.target)
        XCTAssertNil(barButtonItem.handler)
    }
}

/// Unfortunately, there's an apparent limitation in using `sendActionsForControlEvents` on unit-tests.
/// To be able to test them, we're now using swizzling to manually invoke the pair target+action.
extension UIControl {

    static func swizzle_sendAction() {
        let originalSelector = #selector(UIControl.sendAction(_:to:for:))
        let swizzledSelector = #selector(UIControl.swizzle_sendAction(_:to:forEvent:))

        let originalMethod = class_getInstanceMethod(UIControl.self, originalSelector)!
        let swizzledMethod = class_getInstanceMethod(UIControl.self, swizzledSelector)!

        let didAddMethod = class_addMethod(UIControl.self,
                                           originalSelector,
                                           method_getImplementation(swizzledMethod),
                                           method_getTypeEncoding(swizzledMethod))

        if didAddMethod {
            class_replaceMethod(UIControl.self,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }

    // MARK: - Method Swizzling
    @objc private func swizzle_sendAction(_ action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {
        _ = target?.perform(action, with: self, with: UIEvent())
    }
}
