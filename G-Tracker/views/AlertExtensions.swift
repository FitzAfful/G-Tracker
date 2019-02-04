//
//  AlertExtensions.swift
//  G-Tracker
//
//  Created by Paa Quesi Afful on 04/02/2019.
//  Copyright © 2019 Glivion. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
	
	/// Add a textField
	///
	/// - Parameters:
	///   - height: textField height
	///   - hInset: right and left margins to AlertController border
	///   - vInset: bottom margin to button
	///   - configuration: textField
	
	func addOneTextField(configuration: TextField.Config?) {
		let textField = OneTextFieldViewController(vInset: preferredStyle == .alert ? 12 : 0, configuration: configuration)
		let height: CGFloat = OneTextFieldViewController.ui.height + OneTextFieldViewController.ui.vInset
		set(vc: textField, height: height)
	}
}

final class OneTextFieldViewController: UIViewController {
	
	fileprivate lazy var textField: TextField = TextField()
	
	struct ui {
		static let height: CGFloat = 44
		static let hInset: CGFloat = 12
		static var vInset: CGFloat = 12
	}
	
	
	init(vInset: CGFloat = 12, configuration: TextField.Config?) {
		super.init(nibName: nil, bundle: nil)
		view.addSubview(textField)
		ui.vInset = vInset
		
		/// have to set textField frame width and height to apply cornerRadius
		textField.height = ui.height
		textField.width = view.width
		
		configuration?(textField)
		
		preferredContentSize.height = ui.height + ui.vInset
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		textField.width = view.width - ui.hInset * 2
		textField.height = ui.height
		textField.center.x = view.center.x
		textField.center.y = view.center.y - ui.vInset / 2
	}
}


open class TextField: UITextField {
	
	public typealias Config = (TextField) -> Swift.Void
	
	public func configure(configurate: Config?) {
		configurate?(self)
	}
	
	public typealias Action = (UITextField) -> Void
	
	fileprivate var actionEditingChanged: Action?
	
	// Provides left padding for images
	
	override open func leftViewRect(forBounds bounds: CGRect) -> CGRect {
		var textRect = super.leftViewRect(forBounds: bounds)
		textRect.origin.x += leftViewPadding ?? 0
		return textRect
	}
	
	override open func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: (leftTextPadding ?? 8) + (leftView?.width ?? 0) + (leftViewPadding ?? 0), dy: 0)
	}
	
	override open func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: (leftTextPadding ?? 8) + (leftView?.width ?? 0) + (leftViewPadding ?? 0), dy: 0)
	}
	
	
	public var leftViewPadding: CGFloat?
	public var leftTextPadding: CGFloat?
	
	
	public func action(closure: @escaping Action) {
		if actionEditingChanged == nil {
			addTarget(self, action: #selector(TextField.textFieldDidChange), for: .editingChanged)
		}
		actionEditingChanged = closure
	}
	
	@objc func textFieldDidChange(_ textField: UITextField) {
		actionEditingChanged?(self)
	}
}


// MARK: - Properties

public extension UIView {
	
	/// Size of view.
	public var size: CGSize {
		get {
			return self.frame.size
		}
		set {
			self.width = newValue.width
			self.height = newValue.height
		}
	}
	
	/// Width of view.
	public var width: CGFloat {
		get {
			return self.frame.size.width
		}
		set {
			self.frame.size.width = newValue
		}
	}
	
	/// Height of view.
	public var height: CGFloat {
		get {
			return self.frame.size.height
		}
		set {
			self.frame.size.height = newValue
		}
	}
}


@IBDesignable
extension UIView {
	
	@IBInspectable
	/// Should the corner be as circle
	public var circleCorner: Bool {
		get {
			return min(bounds.size.height, bounds.size.width) / 2 == cornerRadius
		}
		set {
			cornerRadius = newValue ? min(bounds.size.height, bounds.size.width) / 2 : cornerRadius
		}
	}
	
	@IBInspectable
	/// Corner radius of view; also inspectable from Storyboard.
	public var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.cornerRadius = circleCorner ? min(bounds.size.height, bounds.size.width) / 2 : newValue
			//abs(CGFloat(Int(newValue * 100)) / 100)
		}
	}
	
	@IBInspectable
	/// Border color of view; also inspectable from Storyboard.
	public var borderColor: UIColor? {
		get {
			guard let color = layer.borderColor else {
				return nil
			}
			return UIColor(cgColor: color)
		}
		set {
			guard let color = newValue else {
				layer.borderColor = nil
				return
			}
			layer.borderColor = color.cgColor
		}
	}
	
	@IBInspectable
	/// Border width of view; also inspectable from Storyboard.
	public var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}
	
	@IBInspectable
	/// Shadow color of view; also inspectable from Storyboard.
	public var shadowColor: UIColor? {
		get {
			guard let color = layer.shadowColor else {
				return nil
			}
			return UIColor(cgColor: color)
		}
		set {
			layer.shadowColor = newValue?.cgColor
		}
	}
	
	@IBInspectable
	/// Shadow offset of view; also inspectable from Storyboard.
	public var shadowOffset: CGSize {
		get {
			return layer.shadowOffset
		}
		set {
			layer.shadowOffset = newValue
		}
	}
	
	@IBInspectable
	/// Shadow opacity of view; also inspectable from Storyboard.
	public var shadowOpacity: Double {
		get {
			return Double(layer.shadowOpacity)
		}
		set {
			layer.shadowOpacity = Float(newValue)
		}
	}
	
	@IBInspectable
	/// Shadow radius of view; also inspectable from Storyboard.
	public var shadowRadius: CGFloat {
		get {
			return layer.shadowRadius
		}
		set {
			layer.shadowRadius = newValue
		}
	}
	
	@IBInspectable
	/// Shadow path of view; also inspectable from Storyboard.
	public var shadowPath: CGPath? {
		get {
			return layer.shadowPath
		}
		set {
			layer.shadowPath = newValue
		}
	}
	
	@IBInspectable
	/// Should shadow rasterize of view; also inspectable from Storyboard.
	/// cache the rendered shadow so that it doesn't need to be redrawn
	public var shadowShouldRasterize: Bool {
		get {
			return layer.shouldRasterize
		}
		set {
			layer.shouldRasterize = newValue
		}
	}
	
	@IBInspectable
	/// Should shadow rasterize of view; also inspectable from Storyboard.
	/// cache the rendered shadow so that it doesn't need to be redrawn
	public var shadowRasterizationScale: CGFloat {
		get {
			return layer.rasterizationScale
		}
		set {
			layer.rasterizationScale = newValue
		}
	}
	
	@IBInspectable
	/// Corner radius of view; also inspectable from Storyboard.
	public var maskToBounds: Bool {
		get {
			return layer.masksToBounds
		}
		set {
			layer.masksToBounds = newValue
		}
	}
}
