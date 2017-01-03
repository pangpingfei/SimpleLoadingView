//
//  ViewController.swift
//  SimpleLoadingViewDemo
//
//  Created by 庞平飞 on 2016/12/31.
//  Copyright © 2016年 PangPingfei. All rights reserved.
//

import UIKit
import SimpleLoadingView


class ViewController: UITableViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		showStartLoadingView()
	}

	override func viewWillAppear(_ animated: Bool) {
		
	}

	override func viewDidAppear(_ animated: Bool) {

	}

	@IBAction func rightBarButtonOnTouch(_ sender: Any) {
		showLoadingView()
	}

}


private extension ViewController {

	// Mock network request
	func showStartLoadingView() {
		SimpleLoading.show(.textBottom("Starting... Please wait..."))
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
//			SimpleLoading.hide()
			SimpleLoading.show(.text("Welcome!"), duration: 2)
		})
	}

	func showLoadingView() {
		let c = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		let action1 = UIAlertAction(title: "show()", style: .default) { (_) in
			SimpleLoading.show(duration: 3)
		}
		let action2 = UIAlertAction(title: "show(.text(\"Loading\"))", style: .default) { (_) in
			SimpleLoading.show(.text("Loading"), duration: 3)
		}
		let action3 = UIAlertAction(title: "show(.textRight(\"Loading\"))", style: .default) { (_) in
			SimpleLoading.show(.textRight("Loading"), duration: 3)
		}
		let action4 = UIAlertAction(title: "show(.textBottom(\"Loading\"))", style: .default) { (_) in
			SimpleLoading.show(.textBottom("Loading"), duration: 3)
		}
		let action5 = UIAlertAction(title: "show(.textLeft(\"Loading\"))", style: .default) { (_) in
			SimpleLoading.show(.textLeft("Loading"), duration: 3)
		}
		let action6 = UIAlertAction(title: "show(.textTop(\"Loading\"))", style: .default) { (_) in
			SimpleLoading.show(.textTop("Loading"), duration: 3)
		}
		let action7 = UIAlertAction(title: "Show(inView: UIView)", style: .destructive) { (_) in
			self.performSegue(withIdentifier: "ToNewView", sender: nil)
		}
		c.addAction(action1)
		c.addAction(action2)
		c.addAction(action3)
		c.addAction(action4)
		c.addAction(action5)
		c.addAction(action6)
		c.addAction(action7)
		c.addAction(cancel)
		present(c, animated: true, completion: nil)
	}

}


extension ViewController {

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		if indexPath.section == 0 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.overApplicationWindow = true
			case 1: SimpleLoading.Config.ignoreInteractionEvents = false
			default: break
			}
		} else if indexPath.section == 1 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.maskViewAlpha = 0.5
			default: break
			}
		} else if indexPath.section == 2 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.superViewColor = .red
			default: break
			}
		} else if indexPath.section == 3 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.viewColor         = .black
			case 1: SimpleLoading.Config.viewAlpha         = 0.75
			case 2: SimpleLoading.Config.viewCornerRadius  = 15
			case 3: SimpleLoading.Config.viewBorderWidth   = 1
			case 4: SimpleLoading.Config.viewBorderColor   = .white
			case 5: SimpleLoading.Config.viewShadowOpacity = 0.8
			default: break
			}
		} else if indexPath.section == 4 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.activityStyle = .whiteLarge
			case 1: SimpleLoading.Config.activityColor = .gray
			default: break
			}
		} else if indexPath.section == 5 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.textColor = .white
			case 1: SimpleLoading.Config.textSize  = 20
			default: break
			}
		} else if indexPath.section == 6 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.horizontalPadding = 30
			case 1: SimpleLoading.Config.verticalPadding   = 30
			case 2: SimpleLoading.Config.horizontalSpacing = 20
			case 3: SimpleLoading.Config.verticalSpacing   = 20
			default: break
			}
		}
		tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
	}


	override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.overApplicationWindow = false
			case 1: SimpleLoading.Config.ignoreInteractionEvents = true
			default: break
			}
		} else if indexPath.section == 1 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.maskViewAlpha = nil
			default: break
			}
		} else if indexPath.section == 2 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.superViewColor = nil
			default: break
			}
		} else if indexPath.section == 3 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.viewColor         = nil
			case 1: SimpleLoading.Config.viewAlpha         = nil
			case 2: SimpleLoading.Config.viewCornerRadius  = nil
			case 3: SimpleLoading.Config.viewBorderWidth   = nil
			case 4: SimpleLoading.Config.viewBorderColor   = nil
			case 5: SimpleLoading.Config.viewShadowOpacity = nil
			default: break
			}
		} else if indexPath.section == 4 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.activityStyle = nil
			case 1: SimpleLoading.Config.activityColor = nil
			default: break
			}
		} else if indexPath.section == 5 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.textColor = nil
			case 1: SimpleLoading.Config.textSize  = nil
			default: break
			}
		} else if indexPath.section == 6 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.horizontalPadding = nil
			case 1: SimpleLoading.Config.verticalPadding   = nil
			case 2: SimpleLoading.Config.horizontalSpacing = nil
			case 3: SimpleLoading.Config.verticalSpacing   = nil
			default: break
			}
		}
		tableView.cellForRow(at: indexPath)?.accessoryType = .disclosureIndicator
	}

}





