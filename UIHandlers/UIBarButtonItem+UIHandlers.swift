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

extension UIBarButtonItem {
    
    /// Initializes a new item using the specified image and other properties.
    public convenience init(image: UIImage?, style: UIBarButtonItem.Style, handler: @escaping (UIBarButtonItem) -> Void) {
        self.init(image: image, style: style, target: nil, action: nil)
        setHandler(handler)
    }
    
    /// Initializes a new item using the specified image and other properties.
    public convenience init(image: UIImage?, style: UIBarButtonItem.Style, handler: @escaping () -> Void) {
        self.init(image: image, style: style, target: nil, action: nil)
        setHandler(handler)
    }
    
    /// Initializes a new item using the specified image and other properties.
    public convenience init(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItem.Style, handler: @escaping (UIBarButtonItem) -> Void) {
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: nil)
        setHandler(handler)
    }
    
    /// Initializes a new item using the specified image and other properties.
    public convenience init(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItem.Style, handler: @escaping () -> Void) {
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: nil)
        setHandler(handler)
    }
    
    /// Initializes a new item using the specified title and other properties.
    public convenience init(title: String?, style: UIBarButtonItem.Style, handler: @escaping (UIBarButtonItem) -> Void) {
        self.init(title: title, style: style, target: nil, action: nil)
        setHandler(handler)
    }
    
    /// Initializes a new item using the specified title and other properties.
    public convenience init(title: String?, style: UIBarButtonItem.Style, handler: @escaping () -> Void) {
        self.init(title: title, style: style, target: nil, action: nil)
        setHandler(handler)
    }
    
    /// Initializes a new item containing the specified system item.
    public convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, handler: @escaping (UIBarButtonItem) -> Void) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
        setHandler(handler)
    }
    
    /// Initializes a new item containing the specified system item.
    public convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, handler: @escaping () -> Void) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
        setHandler(handler)
    }
    
    internal static var handlerKey: UInt8 = 0
    internal var handler: AnyObject? {
        get { return objc_getAssociatedObject(self, &UIBarButtonItem.handlerKey) as AnyObject? }
        set { objc_setAssociatedObject(self, &UIBarButtonItem.handlerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
    /// Sets the handler block for when the item is pressed.
    public func setHandler(_ handler: @escaping (UIBarButtonItem) -> Void) {
        let wrapper = ClosureWrapper1 {
            handler($0 as! UIBarButtonItem) //swiftlint:disable:this force_cast
        }
        target = wrapper
        action = #selector(ClosureWrapper1.invoke)
        self.handler = wrapper
    }
    
    /// Sets the handler block for when the item is pressed.
    public func setHandler(_ handler: @escaping () -> Void) {
        setHandler { _ in handler() }
    }
    
    /// Clears the handler block. Target and action are cleared as well.
    public func clearHandler() {
        target = nil
        action = nil
        handler = nil
    }
}
