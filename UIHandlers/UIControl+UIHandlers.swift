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

import UIKit

/// The base protocol that allows for `Self` to be used when adding handlers.
public protocol ControlHandler {}

extension ControlHandler where Self: UIControl {

    /**
     Adds a handler to be envoked to when a spefic set of control events are triggerd.
     Remeber to use `[unkowned self]` or `[weak self]` when referencing `self` or other targets inside the handler to prevent memory leaks.
     The handler is strongly retained by the `UIControl`.

     - Parameters:
        - controlEvents: A bitmask specifying the control-specific events for which the action method is called. Always specify at least one constant.
        - handler: A handler to be invoked when the condition for the control events are met.
    */
    public func addHandler(for controlEvents: UIControl.Event, _ handler: @escaping (Self) -> Void) {
        let wrapper = ClosureWrapper {
            handler($0 as! Self) //swiftlint:disable:this force_cast
        }
        addTarget(wrapper, action: #selector(ClosureWrapper.invoke), for: controlEvents)
        self.handlers += [wrapper]
    }

    /**
     Adds a handler to be envoked to when a spefic set of control events are triggerd.
     Remeber to use `[unkowned self]` or `[weak self]` when referencing `self` or other targets inside the handler to prevent memory leaks.
     The handler is strongly retained by the `UIControl`.

     - Parameters:
        - controlEvents: A bitmask specifying the control-specific events for which the action method is called. Always specify at least one constant.
        - handler: A handler to be invoked when the condition for the control events are met.
     */
    public func addHandler(for controlEvents: UIControl.Event, _ handler: @escaping () -> Void) {
        addHandler(for: controlEvents) { _ in
            handler()
        }
    }
}

extension UIControl: ControlHandler {}

extension UIControl {

    internal static var handlersKey: UInt8 = 0
    internal var handlers: [ClosureWrapper] {
        get { return objc_getAssociatedObject(self, &UIControl.handlersKey) as? [ClosureWrapper] ?? [] }
        set { return objc_setAssociatedObject(self, &UIControl.handlersKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
}
