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

	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var durationField: UITextField!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		showStartLoadingView()
	}

	override func viewWillAppear(_ animated: Bool) {
		
	}

	override func viewDidAppear(_ animated: Bool) {

	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let c = segue.destination as? NewViewController {
			c.text = sender as? String
		}
	}

	@IBAction func rightBarButtonOnTouch(_ sender: Any) {
		view.endEditing(true)
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
		guard let text = textField.text else { return }
		guard let duration: TimeInterval = TimeInterval(durationField.text!) else {
			SimpleLoading.show(.text("Get duration error, please input number!"))
			return
		}
		let c = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		let action1 = UIAlertAction(title: ".Style.noText", style: .default) { (_) in
			SimpleLoading.show(duration: duration)
		}
		let action2 = UIAlertAction(title: ".Style.text", style: .default) { (_) in
			SimpleLoading.show(.text(text), duration: duration)
		}
		let action3 = UIAlertAction(title: ".Style.textRight", style: .default) { (_) in
			SimpleLoading.show(.textRight(text), duration: duration)
		}
		let action4 = UIAlertAction(title: ".Style.textBottom", style: .default) { (_) in
			SimpleLoading.show(.textBottom(text), duration: duration)
		}
		let action5 = UIAlertAction(title: ".Style.textLeft", style: .default) { (_) in
			SimpleLoading.show(.textLeft(text), duration: duration)
		}
		let action6 = UIAlertAction(title: ".Style.textTop", style: .default) { (_) in
			SimpleLoading.show(.textTop(text), duration: duration)
		}
		let action7 = UIAlertAction(title: "Show(inView: UIView)", style: .destructive) { (_) in
			self.performSegue(withIdentifier: "ToNewView", sender: text)
//			SimpleLoading.show(.textTop(text), duration: duration, inView: self.tableView)
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
			case 4: SimpleLoading.Config.minHorizontalMargin = 50
			case 5: SimpleLoading.Config.minVerticalMargin   = 100
			default: break
			}
		}
		tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
	}


	override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.overApplicationWindow = false
			case 1: SimpleLoading.Config.ignoreInteractionEvents = nil
			default: break
			}
		} else if indexPath.section == 1 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.maskViewAlpha = 0
			default: break
			}
		} else if indexPath.section == 2 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.superViewColor = .clear
			default: break
			}
		} else if indexPath.section == 3 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.viewColor         = .white
			case 1: SimpleLoading.Config.viewAlpha         = 1
			case 2: SimpleLoading.Config.viewCornerRadius  = 5
			case 3: SimpleLoading.Config.viewBorderWidth   = 0
			case 4: SimpleLoading.Config.viewBorderColor   = .black
			case 5: SimpleLoading.Config.viewShadowOpacity = 0
			default: break
			}
		} else if indexPath.section == 4 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.activityStyle = .gray
			case 1: SimpleLoading.Config.activityColor = nil
			default: break
			}
		} else if indexPath.section == 5 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.textColor = .lightGray
			case 1: SimpleLoading.Config.textSize  = 15
			default: break
			}
		} else if indexPath.section == 6 {
			switch indexPath.row {
			case 0: SimpleLoading.Config.horizontalPadding = 20
			case 1: SimpleLoading.Config.verticalPadding   = 15
			case 2: SimpleLoading.Config.horizontalSpacing = 5
			case 3: SimpleLoading.Config.verticalSpacing   = 8
			case 4: SimpleLoading.Config.minHorizontalMargin = 15
			case 5: SimpleLoading.Config.minVerticalMargin   = 20
			default: break
			}
		}
		tableView.cellForRow(at: indexPath)?.accessoryType = .disclosureIndicator
	}

}



extension ViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}

}







