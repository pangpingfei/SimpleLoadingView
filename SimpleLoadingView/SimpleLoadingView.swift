//
//  SimpleLoadingView.swift
//  SimpleLoadingView
//
//  Created by 庞平飞 on 2016/12/31.
//  Copyright © 2016年 PangPingfei. All rights reserved.
//


internal var topMostController: UIViewController? {
	var presentedVC = UIApplication.shared.keyWindow?.rootViewController
	while let pVC = presentedVC?.presentedViewController {
		presentedVC = pVC
	}
	
	return presentedVC
}


internal class SimpleLoadingView: UIView {
	
	deinit {
		#if DEBUG
			debugPrint("SimpleLoadingView deinit")
		#endif
	}

	// only activity
	@IBOutlet weak var viewForStyleA: UIView!
	@IBOutlet weak var activityForStyleA: UIActivityIndicatorView!
	
	@IBOutlet weak var leadingForStyleA: NSLayoutConstraint!
	@IBOutlet weak var topForStyleA: NSLayoutConstraint!
	@IBOutlet weak var trailingForStyleA: NSLayoutConstraint!
	@IBOutlet weak var bottomForStyleA: NSLayoutConstraint!
	
	// only label
	@IBOutlet weak var viewForStyleB: UIView!
	@IBOutlet weak var labelForStyleB: UILabel!
	
	@IBOutlet weak var leadingForStyleB: NSLayoutConstraint!
	@IBOutlet weak var topForStyleB: NSLayoutConstraint!
	@IBOutlet weak var trailingForStyleB: NSLayoutConstraint!
	@IBOutlet weak var bottomForStyleB: NSLayoutConstraint!
	
	// activity on left, label on right
	@IBOutlet weak var viewForStyleC: UIView!
	@IBOutlet weak var activityForStyleC: UIActivityIndicatorView!
	@IBOutlet weak var labelForStyleC: UILabel!
	
	@IBOutlet weak var leadingForStyleC: NSLayoutConstraint!
	@IBOutlet weak var topForStyleC: NSLayoutConstraint!
	@IBOutlet weak var trailingForStyleC: NSLayoutConstraint!
	@IBOutlet weak var bottomForStyleC: NSLayoutConstraint!
	
	@IBOutlet weak var spacingForStyleC: NSLayoutConstraint!
	
	// label on left, actitivty on right
	@IBOutlet weak var viewForStyleD: UIView!
	@IBOutlet weak var labelForStyleD: UILabel!
	@IBOutlet weak var activityForStyleD: UIActivityIndicatorView!
	
	@IBOutlet weak var leadingForStyleD: NSLayoutConstraint!
	@IBOutlet weak var topForStyleD: NSLayoutConstraint!
	@IBOutlet weak var trailingForStyleD: NSLayoutConstraint!
	@IBOutlet weak var bottomForStyleD: NSLayoutConstraint!
	
	@IBOutlet weak var spacingForStyleD: NSLayoutConstraint!
	
	// activity on top, label on bottom
	@IBOutlet weak var viewForStyleE: UIView!
	@IBOutlet weak var activityForStyleE: UIActivityIndicatorView!
	@IBOutlet weak var labelForStyleE: UILabel!
	
	@IBOutlet weak var leadingForStyleE: NSLayoutConstraint!
	@IBOutlet weak var topForStyleE: NSLayoutConstraint!
	@IBOutlet weak var trailingForStyleE: NSLayoutConstraint!
	@IBOutlet weak var bottomForStyleE: NSLayoutConstraint!
	
	@IBOutlet weak var spacingForStyleE: NSLayoutConstraint!
	
	// label on top, activity on bottom
	@IBOutlet weak var viewForStyleF: UIView!
	@IBOutlet weak var labelForStyleF: UILabel!
	@IBOutlet weak var activityForStyleF: UIActivityIndicatorView!
	
	@IBOutlet weak var leadingForStyleF: NSLayoutConstraint!
	@IBOutlet weak var topForStyleF: NSLayoutConstraint!
	@IBOutlet weak var trailingForStyleF: NSLayoutConstraint!
	@IBOutlet weak var bottomForStyleF: NSLayoutConstraint!
	
	@IBOutlet weak var spacingForStyleF: NSLayoutConstraint!

}


internal extension SimpleLoadingView {
	
	static func create(style: SimpleLoading.Style) -> SimpleLoadingView? {
		let bundle = Bundle(identifier: "PangPingfei.SimpleLoadingView")
		let view = bundle?.loadNibNamed("SimpleLoadingView", owner: nil, options: nil)?.first as? SimpleLoadingView
		view?.setupView(style: style)
		return view
	}
	
}


internal extension SimpleLoadingView {
	
	func show(inView: UIView? = nil) {
		alpha = 0
		if let view = inView {
			self.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(self)
			let h = NSLayoutConstraint.constraints(withVisualFormat: "H:|[self]|", options: .alignAllCenterX, metrics: nil, views: ["self" : self])
			let v = NSLayoutConstraint.constraints(withVisualFormat: "V:|[self]|", options: .alignAllCenterY, metrics: nil, views: ["self" : self])
			view.addConstraints(h)
			view.addConstraints(v)
		} else {
			if SimpleLoading.Config.overApplicationWindow {
				UIApplication.shared.windows.first?.addSubview(self)
			} else {
				topMostController!.view.addSubview(self)
			}
		}
		if SimpleLoading.Config.ignoreInteractionEvents {
			UIApplication.shared.beginIgnoringInteractionEvents()
		}
		UIView.animate(withDuration: 0.2) {
			self.alpha = 1.0
		}
	}
	
	func hide(_ completion: @escaping () -> Void) {
		alpha = 1
		UIView.animate(withDuration: 0.2, animations: {
			self.alpha = 0
		}, completion: { _ in
			self.removeFromSuperview()
			if SimpleLoading.Config.ignoreInteractionEvents {
				UIApplication.shared.endIgnoringInteractionEvents()
			}
			completion()
		})
	}
	
}



// MARK: Private

private extension SimpleLoadingView {
	
	func setupView(style: SimpleLoading.Style) {
		
		setupSuperView()
		
		switch style {
			
		case .noText: // StyleA
			setupLoadingView(viewForStyleA)
			setupActivity(activityForStyleA)
			setupPadding(vertical: [topForStyleA, bottomForStyleA], horizontal: [leadingForStyleA, trailingForStyleA])
			viewForStyleA.isHidden = false
			
		case .text(let text): // StyleB
			setupLoadingView(viewForStyleB)
			setupLabel(labelForStyleB, text)
			setupPadding(vertical: [topForStyleB, bottomForStyleB], horizontal: [leadingForStyleB, trailingForStyleB])
			viewForStyleB.isHidden = false
			
		case .textRight(let text): // StyleC
			setupLoadingView(viewForStyleC)
			setupLabel(labelForStyleC, text)
			setupActivity(activityForStyleC)
			setupPadding(vertical: [topForStyleC, bottomForStyleC], horizontal: [leadingForStyleC, trailingForStyleC])
			setupSpacing(vertical: nil, horizontal: spacingForStyleC)
			viewForStyleC.isHidden = false
			
		case .textLeft(let text): // StyleD
			setupLoadingView(viewForStyleD)
			setupLabel(labelForStyleD, text)
			setupActivity(activityForStyleD)
			setupPadding(vertical: [topForStyleD, bottomForStyleD], horizontal: [leadingForStyleD, trailingForStyleD])
			setupSpacing(vertical: nil, horizontal: spacingForStyleD)
			viewForStyleD.isHidden = false
			
		case .textBottom(let text): // StyleE
			setupLoadingView(viewForStyleE)
			setupLabel(labelForStyleE, text)
			setupActivity(activityForStyleE)
			setupPadding(vertical: [topForStyleE, bottomForStyleE], horizontal: [leadingForStyleE, trailingForStyleE])
			setupSpacing(vertical: spacingForStyleE, horizontal: nil)
			viewForStyleE.isHidden = false
			
		case .textTop(let text): // StyleF
			setupLoadingView(viewForStyleF)
			setupLabel(labelForStyleF, text)
			setupActivity(activityForStyleF)
			setupPadding(vertical: [topForStyleF, bottomForStyleF], horizontal: [leadingForStyleF, trailingForStyleF])
			setupSpacing(vertical: spacingForStyleF, horizontal: nil)
			viewForStyleF.isHidden = false
			
		}
		
	}
	
	func setupSuperView() {
		frame = UIScreen.main.bounds
		if let c = SimpleLoading.Config.superViewColor { self.backgroundColor = c }
	}
	
	func setupLoadingView(_ view: UIView) {
		if let c = SimpleLoading.Config.viewColor { view.backgroundColor = c }
		if let a = SimpleLoading.Config.viewAlpha, a >= 0, a <= 1 { view.alpha = a }
		if let r = SimpleLoading.Config.viewCornerRadius { view.layer.cornerRadius = r; view.layer.masksToBounds = true }
		if let w = SimpleLoading.Config.viewBorderWidth { view.layer.borderWidth = w }
		if let c = SimpleLoading.Config.viewBorderColor { view.layer.borderColor = c.cgColor }
		if let o = SimpleLoading.Config.viewShadowOpacity, o > 0, o <= 1 {
			view.layer.masksToBounds = false
			view.layer.shadowOffset = CGSize(width: 0, height: 1)
			view.layer.shadowRadius = view.layer.cornerRadius
			view.layer.shadowOpacity = o
		}
	}
	
	func setupLabel(_ label: UILabel, _ text: String) {
		label.text = text
		if let s = SimpleLoading.Config.textSize { label.font = UIFont.systemFont(ofSize: s) }
		if let c = SimpleLoading.Config.textColor { label.textColor = c }
	}
	
	func setupActivity(_ a: UIActivityIndicatorView) {
		if let s = SimpleLoading.Config.activityStyle { a.activityIndicatorViewStyle = s }
		if let color = SimpleLoading.Config.activityColor { a.color = color }
	}
	
	func setupPadding(vertical v: [NSLayoutConstraint], horizontal h: [NSLayoutConstraint]) {
		if let p = SimpleLoading.Config.verticalPadding { for c in v { c.constant = p } }
		if let p = SimpleLoading.Config.horizontalPadding { for c in h { c.constant = p } }
	}
	
	func setupSpacing(vertical v: NSLayoutConstraint?, horizontal h: NSLayoutConstraint?) {
		if let s = SimpleLoading.Config.verticalSpacing { v?.constant = s }
		if let s = SimpleLoading.Config.horizontalSpacing { h?.constant = s }
	}
	
}




