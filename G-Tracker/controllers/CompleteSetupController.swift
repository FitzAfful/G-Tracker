//
//  CompleteSetupController.swift
//  G-Tracker
//
//  Created by Paa Quesi Afful on 04/02/2019.
//  Copyright © 2019 Glivion. All rights reserved.
//

import UIKit
import SVPinView
import FTIndicator
import LocalAuthentication

class CompleteSetupController: UIViewController {

	@IBOutlet weak var mySwitch: UISwitch!
	@IBOutlet weak var pinView: SVPinView!
	@IBOutlet weak var fingerprintLabel: UILabel!
	var pin: String!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		if #available(iOS 11.0, *) {
			var error: NSError?
			if LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
				switch(LAContext().biometryType){
				case .faceID:
					print("Face ID")
					self.fingerprintLabel.text = "Allow FaceID Login"
					break
				case .touchID:
					print("Touch ID")
					self.fingerprintLabel.text = "Allow TouchID Login"
					break
				case .none:
					print("No ID")
					self.fingerprintLabel.isHidden = true
					self.mySwitch.isHidden = true
					break
				}
			}else{
				self.fingerprintLabel.isHidden = true
				self.mySwitch.isHidden = true
			}
		}else {
			self.fingerprintLabel.isHidden = true
			self.mySwitch.isHidden = true
		}
	}
	
	@IBAction func previous(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func finish(_ sender: Any) {
		if(pin != pinView.getPin()){
			FTIndicator.showError(withMessage: "Please confirm entered passcode")
			return
		}
		UserDefaults.standard.set(pin, forKey: "pin")
		
		let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
		let slideController = myStoryboard.instantiateViewController(withIdentifier: "NavCon") as! UINavigationController
		self.present(slideController, animated: true, completion: nil)
	}
	
}
