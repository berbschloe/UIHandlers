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
    public func addHandler(for controlEvents: UIControl.Event, _ handler: @escaping (Self, UIEvent) -> Void) -> HandlerToken {
        let wrapper = ClosureWrapper2 {
            handler($0 as! Self, $1 as! UIEvent) //swiftlint:disable:this force_cast
        }
        let action = #selector(ClosureWrapper2.invoke(arg1:arg2:))
        addTarget(wrapper, action: action, for: controlEvents)
        self.handlers += [wrapper]

        return HandlerToken(control: self, target: wrapper, action: action, controlEvents: controlEvents)
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
    public func addHandler(for controlEvents: UIControl.Event, _ handler: @escaping (Self) -> Void) -> HandlerToken {
        return addHandler(for: controlEvents) { (sender, _) in
            handler(sender)
        }
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
    public func addHandler(for controlEvents: UIControl.Event, _ handler: @escaping () -> Void) -> HandlerToken {
        return addHandler(for: controlEvents) { _ in
            handler()
        }
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

    public func removeTarget() {
        control.handlers.removeAll { $0 === target }
        control.removeTarget(target, action: action, for: controlEvents)
    }
}
