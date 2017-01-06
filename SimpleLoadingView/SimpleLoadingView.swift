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
	
	fileprivate var ignoreInteractionEvents: Bool = false
	
	fileprivate lazy var view: UIView = { [unowned self] in
		let view = UIView()
		view.backgroundColor = SimpleLoading.Config.viewColor
		view.alpha = SimpleLoading.Config.viewAlpha
		view.layer.cornerRadius = SimpleLoading.Config.viewCornerRadius
		view.layer.masksToBounds = true
		view.layer.borderWidth = SimpleLoading.Config.viewBorderWidth
		view.layer.borderColor = SimpleLoading.Config.viewBorderColor.cgColor
		let opacity = SimpleLoading.Config.viewShadowOpacity
		if opacity > 0, opacity <= 1 {
			view.layer.masksToBounds = false
			view.layer.shadowOffset = CGSize(width: 0, height: 1)
			view.layer.shadowRadius = view.layer.cornerRadius
			view.layer.shadowOpacity = opacity
		}
		view.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(view)
		return view
	}()

	fileprivate lazy var activity: UIActivityIndicatorView = { [unowned self] in
		let activity = UIActivityIndicatorView(activityIndicatorStyle: SimpleLoading.Config.activityStyle)
		if let color = SimpleLoading.Config.activityColor { activity.color = color }
		activity.hidesWhenStopped = true
		activity.startAnimating()
		activity.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(activity)
		return activity
	}()

	fileprivate lazy var label: UILabel = { [unowned self] in
		let label = UILabel()
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: SimpleLoading.Config.textSize)
		label.textColor = SimpleLoading.Config.textColor
		label.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(label)
		return label
	}()


	init(style: SimpleLoading.Style) {
		super.init(frame: UIScreen.main.bounds)
		setupView(style: style)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}


internal extension SimpleLoadingView {

	func show(inView: UIView? = nil) {
		var parentView: UIView!
		if let view = inView { parentView = view } else {
			if SimpleLoading.Config.overApplicationWindow {
				parentView = UIApplication.shared.windows.first
			} else {
				parentView = topMostController!.view
			}
		}
		self.alpha = 0
		self.translatesAutoresizingMaskIntoConstraints = false
		parentView.addSubview(self)
		parentView.addConstraints(nil, "|[self]|", metrics: nil, views: ["self" : self])

		if let ignore = SimpleLoading.Config.ignoreInteractionEvents, ignore {
			UIApplication.shared.beginIgnoringInteractionEvents()
			ignoreInteractionEvents = true
		} else {
			if inView == nil {
				UIApplication.shared.beginIgnoringInteractionEvents()
				ignoreInteractionEvents = true
			}
		}
		
		UIView.animate(withDuration: 0.2) { self.alpha = 1.0 }
	}

	func hide(_ completion: @escaping () -> Void) {
		alpha = 1
		UIView.animate(withDuration: 0.2, animations: {
			self.alpha = 0
		}, completion: { _ in
			self.removeFromSuperview()
			if self.ignoreInteractionEvents { UIApplication.shared.endIgnoringInteractionEvents() }
			completion()
		})
	}

}



// MARK: Private

private extension SimpleLoadingView {

	func setupView(style: SimpleLoading.Style) {

		// self
		self.backgroundColor = SimpleLoading.Config.superViewColor

		// self -> view
		var metrics = ["margin": SimpleLoading.Config.minHorizontalMargin]
		self.addConstraints("H", "|-(>=margin)-[view]-(>=margin)-|", metrics: metrics, views: ["view": view])
		metrics = ["margin": SimpleLoading.Config.minVerticalMargin]
		self.addConstraints("V", "|-(>=margin)-[view]-(>=margin)-|", metrics: metrics, views: ["view": view])
		self.addConstraint(with: view, attribute: .centerX)
		self.addConstraint(with: view, attribute: .centerY)


		switch style {

		case .noText:
			// self -> view -> activity
			let metrics = ["padding": SimpleLoading.Config.verticalPadding]
			view.addConstraints(nil, "|-(padding)-[activity]-(padding)-|", metrics: metrics, views: ["activity": activity])

		case .text(let text):
			// self -> view -> label
			label.numberOfLines = 0
			label.text = text
			var metrics = ["padding": SimpleLoading.Config.horizontalPadding]
			view.addConstraints("H", "|-(padding)-[label]-(padding)-|", metrics: metrics, views: ["label": label])
			metrics = ["padding": SimpleLoading.Config.verticalPadding]
			view.addConstraints("V", "|-(padding)-[label]-(padding)-|", metrics: metrics, views: ["label": label])

		case .textRight(let text):
			// self -> view -> activity | label
			label.numberOfLines = 1
			label.text = text
			var metrics = ["padding": SimpleLoading.Config.horizontalPadding, "spacing": SimpleLoading.Config.horizontalSpacing]
			view.addConstraints("H", "|-(padding)-[activity]-(spacing)-[label]-(padding)-|", metrics: metrics, views: ["activity":activity, "label":label])
			metrics = ["padding": SimpleLoading.Config.verticalPadding]
			view.addConstraints("V", "|-(padding)-[activity]-(padding)-|", metrics: metrics, views: ["activity":activity])
			view.addConstraint(with: label, attribute: .centerY)

		case .textLeft(let text):
			// self -> view -> label | activity
			label.numberOfLines = 1
			label.lineBreakMode = .byTruncatingHead
			label.text = text
			var metrics = ["padding": SimpleLoading.Config.horizontalPadding, "spacing": SimpleLoading.Config.horizontalSpacing]
			view.addConstraints("H", "|-(padding)-[label]-(spacing)-[activity]-(padding)-|", metrics: metrics, views: ["activity":activity, "label":label])
			metrics = ["padding": SimpleLoading.Config.verticalPadding]
			view.addConstraints("V", "|-(padding)-[activity]-(padding)-|", metrics: metrics, views: ["activity":activity])
			view.addConstraint(with: label, attribute: .centerY)
			
		case .textBottom(let text):
			// self -> view -> activity -- label
			label.text = text
			var metrics = ["padding": SimpleLoading.Config.horizontalPadding]
			view.addConstraints("H", "|-(padding)-[label]-(padding)-|", metrics: metrics, views: ["label":label])
			metrics = ["padding": SimpleLoading.Config.verticalPadding, "spacing": SimpleLoading.Config.verticalSpacing]
			view.addConstraints("V", "|-(padding)-[activity]-(spacing)-[label]-(padding)-|", metrics: metrics, views: ["activity":activity, "label":label])
			view.addConstraint(with: activity, attribute: .centerX)

		case .textTop(let text):
			// self -> view -> label -- activity
			label.text = text
			var metrics = ["padding": SimpleLoading.Config.horizontalPadding]
			view.addConstraints("H", "|-(padding)-[label]-(padding)-|", metrics: metrics, views: ["label":label])
			metrics = ["padding": SimpleLoading.Config.verticalPadding, "spacing": SimpleLoading.Config.verticalSpacing]
			view.addConstraints("V", "|-(padding)-[label]-(spacing)-[activity]-(padding)-|", metrics: metrics, views: ["activity":activity, "label":label])
			view.addConstraint(with: activity, attribute: .centerX)
		}

	}


}



// MARK: - UIView extension

fileprivate extension UIView {

	// direction: "H" or "V", nil -> both
	func addConstraints(_ direction: String?, _ format: String, metrics: [String: Any]?, views: [String: Any]) {
		let noLayoutOptions = NSLayoutFormatOptions(rawValue: 0)
		var cs = [NSLayoutConstraint]()
		if let d = direction {
			cs += NSLayoutConstraint.constraints(withVisualFormat: d + ":" + format, options: noLayoutOptions, metrics: metrics, views: views)
		} else {
			cs += NSLayoutConstraint.constraints(withVisualFormat: "V:" + format, options: noLayoutOptions, metrics: metrics, views: views)
			cs += NSLayoutConstraint.constraints(withVisualFormat: "H:" + format, options: noLayoutOptions, metrics: metrics, views: views)

		}
		self.addConstraints(cs)
	}

	func addConstraint(with view: UIView, attribute: NSLayoutAttribute, relatedBy: NSLayoutRelation = .equal) {
		let constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: relatedBy, toItem: self, attribute: attribute, multiplier: 1, constant: 0)
		self.addConstraint(constraint)
	}
}



