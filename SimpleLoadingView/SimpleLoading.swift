//
//  SimpleLoading.swift
//  SimpleLoadingView
//
//  Created by 庞平飞 on 2016/12/31.
//  Copyright © 2016年 PangPingfei. All rights reserved.
//


public struct SimpleLoading {

	fileprivate static var maskView: UIView!
	fileprivate static var loadingView: SimpleLoadingView?

}


public extension SimpleLoading {
	
	/// SimpleLoading global settings
	public struct Config {
		
		public static var overApplicationWindow: Bool = false // default is false
		public static var ignoreInteractionEvents: Bool = true // default is true
		
		/// Mask view alpha.
		public static var maskViewAlpha: CGFloat? // [0,1] range. default is 0
		
		/// Super view properties.
		public static var superViewColor: UIColor? // default is .clear
		
		/// Loading view properties.
		public static var viewColor: UIColor? // default is .white
		public static var viewAlpha: CGFloat? // [0,1] range. default is 1
		public static var viewCornerRadius: CGFloat? // default is 5
		public static var viewBorderWidth: CGFloat? // default is 0
		public static var viewBorderColor: UIColor? // default is opaque black
		public static var viewShadowOpacity: Float? // [0,1] range. default is 0
		
		/// Activity properties.
		public static var activityStyle: UIActivityIndicatorViewStyle? // Default is .gray
		public static var activityColor: UIColor? // default is nil
		
		/// Text properties.
		public static var textColor: UIColor?  // default is .lightGray
		public static var textSize: CGFloat?  // default is 15
		
		/// Spacing between text or activity and edge.
		public static var verticalPadding: CGFloat? // default is 15
		public static var horizontalPadding: CGFloat? // default is 20 (Style.noText is 15)
		
		/// Spacing between activity and text.
		public static var verticalSpacing: CGFloat?  // default is 8
		public static var horizontalSpacing: CGFloat?  // default is 5
	
	}
	
	/// SimpleLoading style
	public enum Style {
		/// Only activity.
		case noText
		/// Only text.
		case text(String)
		/// Activity on left, text on right.
		case textRight(String)
		/// Text on left, activity on right.
		case textLeft(String)
		/// Activity on top, text on bottom.
		case textBottom(String)
		/// Text on top, activity on bottom.
		case textTop(String)
		
	}
	
}


public extension SimpleLoading {

	/// Show SimpleLoadingView
	/// If there is a SimpleLoadingView already, it will call 'hide()' function first.
	/// - Parameters:
	///	 - style: SimpleLoading.Style. default is .noText
	///  - duration: TimeInterval. SimpleLoadingView will hide after it. default is nil, you need to hide view use ‘hide()’
	///  - inView: UIView. SimpleLoadingView will be added to the view. default is nil
	public static func show(_ style: SimpleLoading.Style = .noText, duration: TimeInterval? = nil, inView: UIView? = nil) {
		
		guard loadingView == nil else {
			hide {
				show(style, duration: duration, inView: inView)
			}
			return
		}
		
		guard topMostController != nil else {
			debugPrint("You don't have any views set. You may be calling them in viewDidLoad. Try viewDidAppear instead.")
			return
		}
		
		guard let view = SimpleLoadingView.create(style: style) else {
			debugPrint("Failed to create SimpleLoadingView.")
			return
		}
		
		self.loadingView = view
		
		DispatchQueue.main.async {
			if let alpha = SimpleLoading.Config.maskViewAlpha, alpha > 0, alpha <= 1 {
				if maskView == nil {
					maskView = UIView(frame: UIApplication.shared.keyWindow!.frame)
				}
				maskView.backgroundColor = UIColor.black.withAlphaComponent(0)
				topMostController?.view.addSubview(maskView)
				UIView.animate(withDuration: 0.2, animations: {
					maskView.backgroundColor = maskView.backgroundColor?.withAlphaComponent(alpha)
				})
			}
			view.show(inView: inView)
		}
		
		if let duration = duration {
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
				hide()
			})
		}
		
	}

	/// Hide SimpleLoadingView
	/// - Parameters:
	///	 - completion: Closure. default is nil
	public static func hide(_ completion: (() -> Void)? = nil) {
		
		guard loadingView != nil else {
			debugPrint("No SimpleLoadingView...")
			return
		}

		func removeMaskView() {
			if maskView != nil {
				UIView.animate(withDuration: 0.2, animations: {
					maskView.backgroundColor = maskView.backgroundColor?.withAlphaComponent(0)
				}, completion: { _ in
					maskView.removeFromSuperview()
					completion?()
				})
			} else {
				completion?()
			}
		}
		
		func removeView() {
			loadingView?.hide() {
				self.loadingView = nil
				removeMaskView()
			}
		}

		if Thread.current.isMainThread { removeView() } else {
			DispatchQueue.main.async { removeView() }
		}
		
	}


}







