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

extension UIView {

    /// Attaches a tap gesture recognizer to the view.
    @discardableResult
    public func addTapHandler(numberOfTapsRequired: Int = 1, handler: @escaping (UITapGestureRecognizer) -> Void) -> UITapGestureRecognizer {
        let recognizer = addHandler(handler: handler)
        recognizer.numberOfTapsRequired = numberOfTapsRequired
        return recognizer
    }

    /// Attaches a long press gesture recognizer to the view.
    @discardableResult
    public func addLongPressHandler(_ handler: @escaping (UILongPressGestureRecognizer) -> Void) -> UILongPressGestureRecognizer {
       return addHandler(handler: handler)
    }

    /// Attaches a pan gesture recognizer to the view.
    @discardableResult
    public func addPanHandler(_ handler: @escaping (UIPanGestureRecognizer) -> Void) -> UIPanGestureRecognizer {
        return addHandler(handler: handler)
    }

    /// Attaches a swipe gesture recognizer to the view.
    @discardableResult
    public func addSwipeHandler(direction: UISwipeGestureRecognizer.Direction = .right, _ handler: @escaping (UISwipeGestureRecognizer) -> Void) -> UISwipeGestureRecognizer {
        let recognizer = addHandler(handler: handler)
        recognizer.direction = direction
        return recognizer
    }

    /// Attaches a pinch gesture recognizer to the view.
    @discardableResult
    public func addPinchHandler(_ handler: @escaping (UIPinchGestureRecognizer) -> Void) -> UIPinchGestureRecognizer {
        return addHandler(handler: handler)
    }

    /// Attaches a rotation gesture recognizer to the view.
    @discardableResult
    public func addRotationHandler(_ handler: @escaping (UIRotationGestureRecognizer) -> Void) -> UIRotationGestureRecognizer {
        return addHandler(handler: handler)
    }

    /// Attaches a screen edge pan gesture recognizer to the view.
    @discardableResult
    public func addScreenEdgePanHandler(edges: UIRectEdge = .all, _ handler: @escaping (UIScreenEdgePanGestureRecognizer) -> Void) -> UIScreenEdgePanGestureRecognizer {
        let recognizer = addHandler(handler: handler)
        recognizer.edges = edges
        return recognizer
    }

    @discardableResult
    private func addHandler<T: UIGestureRecognizer>(handler: @escaping (T) -> Void) -> T {
        let wrapper = ClosureWrapper {
            handler($0 as! T) //swiftlint:disable:this force_cast
        }
        let recognizer = T(target: wrapper, action: #selector(ClosureWrapper.invoke(sender:)))
        addGestureRecognizer(recognizer)
        self.handlers += [wrapper]
        return recognizer
    }
}
