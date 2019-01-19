//
//  ViewController.swift
//  G-Tracker
//
//  Created by Fitzgerald Afful on 17/01/2019.
//  Copyright © 2019 Glivion. All rights reserved.
//

import UIKit
import FTIndicator

class AddCarController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var channelTF: ACFloatingTextfield!
	@IBOutlet weak var keyTF: ACFloatingTextfield!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		channelTF.delegate = self
		keyTF.delegate = self
		
		let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap2))
		self.view.isUserInteractionEnabled = true
		self.view.addGestureRecognizer(tapGesture2)
		
	}
	
	@objc func handleTap2(sender: UITapGestureRecognizer) {
		self.view.endEditing(true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		if(textField == keyTF){
			self.view.endEditing(true)
			self.addCar(self.channelTF)
		}else{
			_ = keyTF.becomeFirstResponder()
		}
		return true;
	}

	@IBAction func addCar(_ sender: Any) {
		if(channelTF.text!.isEmpty){
			channelTF.showErrorWithText(errorText: "Please enter Car's Channel Name")
		}else if(keyTF.text!.isEmpty){
			keyTF.showErrorWithText(errorText: "Please enter Car's Secret Key")
		}else{
			FTIndicator.showProgress(withMessage: "Saving Car")
			APIClient.getCarDetails(channelName: channelTF.text!, secretKey: keyTF.text!) { (result) in
				switch result {
				case .success(let response):
					print(response)
					var channel = response.channel
					channel.feeds = response.feeds
					channel.secret_key = self.keyTF.text!
					channel.channel_key = self.channelTF.text!
					RealmManager().save(channel: channel)
					FTIndicator.dismissProgress()
					self.navigationController?.popViewController(animated: true)
				case .failure(let error):
					print(error.localizedDescription)
					FTIndicator.dismissProgress()
					self.handleError(error)
				}
			}
		}
	}
	
	func handleError(_ error:Error){
		var message = "Error. Please try again"
		if error is ApiError{
			let apiError = error as! ApiError
			let statusCode = apiError.httpUrlResponse.statusCode
			switch statusCode{
			case 401:
				message = "Invalid Credentials. Please check and try again"
				break
			default:
				message = "Invalid Credentials. Please check and try again"
				break
			}
		}else if error is NetworkRequestError{
			message = "please check your internet connection and try again"
		}
		let alert = UIAlertController(title: "oops!", message:message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}

}

