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

import Foundation

internal class ClosureWrapper {

    private let closure: (Any) -> Void

    init(closure: @escaping (Any) -> Void) {
        self.closure = closure
    }

    @objc
    func invoke(arg: Any) {
        closure(arg)
    }
}

internal class ClosureWrapper2 {

    private let closuer: (Any, Any) -> Void

    init(closuer: @escaping (Any, Any) -> Void) {
        self.closuer = closuer
    }

    @objc
    func invoke(arg1: Any, arg2: Any) {
        closuer(arg1, arg2)
    }
}

extension UIView {

    internal static var handlersKey: UInt8 = 0
    internal var handlers: [AnyObject] {
        get { return objc_getAssociatedObject(self, &UIControl.handlersKey) as? [AnyObject] ?? [] }
        set { return objc_setAssociatedObject(self, &UIControl.handlersKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
}
