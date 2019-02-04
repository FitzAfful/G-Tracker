//
//  LoginController.swift
//  G-Tracker
//
//  Created by Paa Quesi Afful on 04/02/2019.
//  Copyright © 2019 Glivion. All rights reserved.
//

import UIKit
import SVPinView
import FTIndicator
import LocalAuthentication

class LoginController: UIViewController {

	@IBOutlet weak var pinView: SVPinView!
	var pin = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()

		touchIDLogin()
	}
	
	func touchIDLogin(){
		let context = LAContext()
		var error: NSError?
		
		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			// 3
			let reason = "Authenticate with Touch ID"
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: {(succes, error) in
				if succes {
					self.finishAuth(pinString: UserDefaults.standard.string(forKey: "pin")!)
				}
				else {
					FTIndicator.showError(withMessage: "Touch ID Authentication Failed")
				}
			})
		}
		else {
			//FTIndicator.showError(withMessage: "Touch ID not available")
		}
	}
	
	
	@IBAction func finish(_ sender: Any) {
		finishAuth(pinString: pinView.getPin())
	}
	
	func finishAuth(pinString: String){
		if (pinString == UserDefaults.standard.string(forKey: "pin")){
			let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let slideController = myStoryboard.instantiateViewController(withIdentifier: "NavCon") as! UINavigationController
			self.present(slideController, animated: true, completion: nil)
		}else {
			FTIndicator.showError(withMessage: "Please enter a correct passcode")
		}
	}
}
