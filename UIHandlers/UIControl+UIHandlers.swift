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

/// A base protocol that allows for `Self` to be used when adding handlers.
public protocol ControlHandler {}

extension UIControl: ControlHandler {}

extension ControlHandler where Self: UIControl {

    /**
     Adds a handler to be envoked to when a spefic set of control events are triggerd.
     Remeber to use `[unkowned self]` or `[weak self]` when referencing `self` or other targets inside the handler to prevent memory leaks.
     The handler is strongly retained by the `UIControl`.

     - Parameters:
     - controlEvents: A bitmask specifying the control-specific events for which the action method is called. Always specify at least one constant.
     - handler: A handler to be invoked when the condition for the control events are met.
     */

    @discardableResult
    public func addHandler(for controlEvents: UIControl.Event, handler: @escaping (Self, UIEvent) -> Void) -> HandlerToken {
        return _addTarget(
            ClosureWrapper2 { handler($0 as! Self, $1 as! UIEvent) }, //swiftlint:disable:this force_cast
            action: #selector(ClosureWrapper2.invoke),
            for: controlEvents
        )
    }

    /**
     Adds a handler to be envoked to when a spefic set of control events are triggerd.
     Remeber to use `[unkowned self]` or `[weak self]` when referencing `self` or other targets inside the handler to prevent memory leaks.
     The handler is strongly retained by the `UIControl`.

     - Parameters:
        - controlEvents: A bitmask specifying the control-specific events for which the action method is called. Always specify at least one constant.
        - handler: A handler to be invoked when the condition for the control events are met.
    */
    @discardableResult
    public func addHandler(for controlEvents: UIControl.Event, handler: @escaping (Self) -> Void) -> HandlerToken {
        return _addTarget(
            ClosureWrapper1 { handler($0 as! Self) }, //swiftlint:disable:this force_cast
            action: #selector(ClosureWrapper1.invoke),
            for: controlEvents
        )
    }

    /**
     Adds a handler to be envoked to when a spefic set of control events are triggerd.
     Remeber to use `[unkowned self]` or `[weak self]` when referencing `self` or other targets inside the handler to prevent memory leaks.
     The handler is strongly retained by the `UIControl`.

     - Parameters:
        - controlEvents: A bitmask specifying the control-specific events for which the action method is called. Always specify at least one constant.
        - handler: A handler to be invoked when the condition for the control events are met.
     */

    @discardableResult
    public func addHandler(for controlEvents: UIControl.Event, handler: @escaping () -> Void) -> HandlerToken {
        return _addTarget(
            ClosureWrapper { handler() },
            action: #selector(ClosureWrapper.invoke),
            for: controlEvents
        )
    }

    private func _addTarget(_ target: AnyObject, action: Selector, for controlEvents: UIControl.Event) -> HandlerToken {
        addTarget(target, action: action, for: controlEvents)
        self.handlers += [target]
        return HandlerToken(control: self, target: target, action: action, controlEvents: controlEvents)
    }
}

public class HandlerToken {

    private let control: UIControl
    private let target: AnyObject
    private let action: Selector
    private let controlEvents: UIControl.Event

    internal init(control: UIControl, target: AnyObject, action: Selector, controlEvents: UIControl.Event) {
        self.control = control
        self.target = target
        self.action = action
        self.controlEvents = controlEvents
    }

    /// Call this to stop receving events with the supplied control event.
    public func removeTarget() {
        control.handlers.removeAll { $0 === target }
        control.removeTarget(target, action: action, for: controlEvents)
    }
}
