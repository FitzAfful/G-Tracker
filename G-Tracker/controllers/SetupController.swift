//
//  SetupController.swift
//  G-Tracker
//
//  Created by Paa Quesi Afful on 04/02/2019.
//  Copyright © 2019 Glivion. All rights reserved.
//

import UIKit
import SVPinView
import FTIndicator

class SetupController: UIViewController {

	@IBOutlet weak var pinView: SVPinView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		pinView.style = .underline
		pinView.keyboardType = .numberPad
    }
	
	@IBAction func `continue`(_ sender: Any) {
		let pin = pinView.getPin()
		if((pin.isEmpty) || (pin.count < 4)){
			FTIndicator.showError(withMessage: "Please enter a valid 4-digit passcode")
			return
		}
		let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
		let slideController = myStoryboard.instantiateViewController(withIdentifier: "CompleteSetupController") as! CompleteSetupController
		slideController.pin = pin
		self.present(slideController, animated: true, completion: nil)
	}
	
}
