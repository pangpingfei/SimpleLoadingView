//
//  NewViewController.swift
//  SimpleLoadingView
//
//  Created by 庞平飞 on 2017/1/2.
//  Copyright © 2017年 PangPingfei. All rights reserved.
//

import UIKit
import SimpleLoadingView

class NewViewController: UIViewController {
	
	@IBOutlet weak var textView: UITextView!
	
	override func viewDidLoad() {
		SimpleLoading.show(inView: self.view)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		SimpleLoading.hide()
	}
	
	
	@IBAction func rightBarButtonOnTouch(_ sender: Any) {
		SimpleLoading.hide()
	}
	
}
