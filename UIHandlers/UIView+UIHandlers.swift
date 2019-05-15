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

    /// Attaches a tap gesture recognizer to the view.
    @discardableResult
    public func addTapHandler(numberOfTapsRequired: Int = 1, handler: @escaping () -> Void) -> UITapGestureRecognizer {
        return addTapHandler(numberOfTapsRequired: numberOfTapsRequired) { _ in handler() }
    }
}

extension UIView {

    /// Attaches a tap gesture recognizer to the view with numberOfTapsRequired set to 2.
    @discardableResult
    public func addDoubleTapHandler(handler: @escaping (UITapGestureRecognizer) -> Void) -> UITapGestureRecognizer {
        return addTapHandler(numberOfTapsRequired: 2, handler: handler)
    }

    /// Attaches a tap gesture recognizer to the view with numberOfTapsRequired set to 2.
    @discardableResult
    public func addDoubleTapHandler(handler: @escaping () -> Void) -> UITapGestureRecognizer {
        return addDoubleTapHandler { _ in handler()}
    }
}

extension UIView {

    /// Attaches a long press gesture recognizer to the view.
    @discardableResult
    public func addLongPressHandler(handler: @escaping (UILongPressGestureRecognizer) -> Void) -> UILongPressGestureRecognizer {
       return addHandler(handler: handler)
    }

    /// Attaches a long press gesture recognizer to the view.
    @discardableResult
    public func addLongPressHandler(handler: @escaping () -> Void) -> UILongPressGestureRecognizer {
        return addLongPressHandler { _ in handler() }
    }
}

extension UIView {

    /// Attaches a pan gesture recognizer to the view.
    @discardableResult
    public func addPanHandler(handler: @escaping (UIPanGestureRecognizer) -> Void) -> UIPanGestureRecognizer {
        return addHandler(handler: handler)
    }

    /// Attaches a pan gesture recognizer to the view.
    @discardableResult
    public func addPanHandler(handler: @escaping () -> Void) -> UIPanGestureRecognizer {
        return addPanHandler { _ in handler() }
    }
}

extension UIView {

    /// Attaches a swipe gesture recognizer to the view.
    @discardableResult
    public func addSwipeHandler(direction: UISwipeGestureRecognizer.Direction, handler: @escaping (UISwipeGestureRecognizer) -> Void) -> UISwipeGestureRecognizer {
        let recognizer = addHandler(handler: handler)
        recognizer.direction = direction
        return recognizer
    }

    /// Attaches a swipe gesture recognizer to the view.
    @discardableResult
    public func addSwipeHandler(direction: UISwipeGestureRecognizer.Direction, handler: @escaping () -> Void) -> UISwipeGestureRecognizer {
        return addSwipeHandler(direction: direction) { _ in handler() }
    }
}

extension UIView {

    /// Attaches a pinch gesture recognizer to the view.
    @discardableResult
    public func addPinchHandler(handler: @escaping (UIPinchGestureRecognizer) -> Void) -> UIPinchGestureRecognizer {
        return addHandler(handler: handler)
    }

    /// Attaches a pinch gesture recognizer to the view.
    @discardableResult
    public func addPinchHandler(handler: @escaping () -> Void) -> UIPinchGestureRecognizer {
        return addPinchHandler { _ in handler() }
    }
}

extension UIView {
    
    /// Attaches a rotation gesture recognizer to the view.
    @discardableResult
    public func addRotationHandler(handler: @escaping (UIRotationGestureRecognizer) -> Void) -> UIRotationGestureRecognizer {
        return addHandler(handler: handler)
    }

    /// Attaches a rotation gesture recognizer to the view.
    @discardableResult
    public func addRotationHandler(handler: @escaping () -> Void) -> UIRotationGestureRecognizer {
        return addRotationHandler { _ in handler() }
    }
}

extension UIView {

    /// Attaches a screen edge pan gesture recognizer to the view.
    @discardableResult
    public func addScreenEdgePanHandler(edges: UIRectEdge, handler: @escaping (UIScreenEdgePanGestureRecognizer) -> Void) -> UIScreenEdgePanGestureRecognizer {
        let recognizer = addHandler(handler: handler)
        recognizer.edges = edges
        return recognizer
    }

    /// Attaches a screen edge pan gesture recognizer to the view.
    @discardableResult
    public func addScreenEdgePanHandler(edges: UIRectEdge, handler: @escaping () -> Void) -> UIScreenEdgePanGestureRecognizer {
        return addScreenEdgePanHandler(edges: edges) { _ in handler() }
    }
}

extension UIView {

    private func addHandler<T: UIGestureRecognizer>(handler: @escaping (T) -> Void) -> T {
        let wrapper = ClosureWrapper1 {
            handler($0 as! T) //swiftlint:disable:this force_cast
        }
        let recognizer = T(target: wrapper, action: #selector(ClosureWrapper1.invoke(arg:)))
        addGestureRecognizer(recognizer)
        self.handlers += [wrapper]
        return recognizer
    }
}
