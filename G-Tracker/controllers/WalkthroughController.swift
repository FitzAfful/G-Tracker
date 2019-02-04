//
//  WalkthroughController.swift
//  G-Tracker
//
//  Created by Paa Quesi Afful on 29/01/2019.
//  Copyright © 2019 Glivion. All rights reserved.
//

import UIKit
import OnboardingKit

class WalkthroughController: UIViewController {

	@IBOutlet weak var onboardingView: OnboardingView!
	@IBOutlet weak var nextButton: UIButton!
	
	// MARK: Properties
	
	private let model = DataModel()
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.nextButton.alpha = 0
		
		onboardingView.dataSource = model
		onboardingView.delegate = model
		
		model.didShow = { page in
			if page == 2 {
				UIView.animate(withDuration: 0.3) {
					self.nextButton.alpha = 1
				}
			}
		}
		
		model.willShow = { page in
			if page != 2 {
				self.nextButton.alpha = 0
			}
		}
	}
	
	@IBAction func createPin(_ sender: Any) {
	}
	public override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}



public final class DataModel: NSObject, OnboardingViewDelegate, OnboardingViewDataSource {
	
	public var didShow: ((Int) -> Void)?
	public var willShow: ((Int) -> Void)?
	
	public func numberOfPages() -> Int {
		return 3
	}
	
	public func onboardingView(_ onboardingView: OnboardingView, configurationForPage page: Int) -> OnboardingConfiguration {
		switch page {
			
		case 0:
			return OnboardingConfiguration(
				image: UIImage(named: "icons8_v2")!,
				itemImage: UIImage(named: "time_small1")!,
				pageTitle: "G-Tracker",
				pageDescription: "Real-time Tracking \n\nTrack your vehicles Everywhere",
				backgroundImage: UIImage(named: "BackgroundRed"),
				topBackgroundImage: nil,
				bottomBackgroundImage: UIImage(named: "WavesImage")
			)
			
		case 1:
			return OnboardingConfiguration(
				image: UIImage(named: "icons8_v4")!,
				itemImage: UIImage(named: "time_small1")!,
				pageTitle: "G-Tracker",
				pageDescription: "Accurate Data \n\nTrack your vehicles with Efficiency",
				backgroundImage: UIImage(named: "BackgroundBlue"),
				topBackgroundImage: nil,
				bottomBackgroundImage: UIImage(named: "WavesImage")
			)
			
		case 2:
			return OnboardingConfiguration(
				image: UIImage(named: "icons8_v5")!,
				itemImage: UIImage(named: "time_small1")!,
				pageTitle: "G-Tracker",
				pageDescription: "Ease of use \n\nTrack your vehicles with our friendly User Experience",
				backgroundImage: UIImage(named: "BackgroundOrange"),
				topBackgroundImage: nil,
				bottomBackgroundImage: UIImage(named: "WavesImage")
			)
			
		default:
			fatalError("Out of range!")
		}
	}
	
	public func onboardingView(_ onboardingView: OnboardingView, configurePageView pageView: PageView, atPage page: Int) {
		pageView.titleLabel.textColor = UIColor.white
		pageView.titleLabel.layer.shadowOpacity = 0.6
		pageView.titleLabel.layer.shadowColor = UIColor.black.cgColor
		pageView.titleLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
		pageView.titleLabel.layer.shouldRasterize = true
		pageView.titleLabel.layer.rasterizationScale = UIScreen.main.scale
		
		if DeviceTarget.IS_IPHONE_4 {
			pageView.titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
			pageView.descriptionLabel.font = UIFont.systemFont(ofSize: 15)
		}
	}
	
	public func onboardingView(_ onboardingView: OnboardingView, didSelectPage page: Int) {
		print("Did select pge \(page)")
		didShow?(page)
	}
	
	public func onboardingView(_ onboardingView: OnboardingView, willSelectPage page: Int) {
		print("Will select page \(page)")
		willShow?(page)
	}
}


public struct DeviceTarget {
	public static let CURRENT_DEVICE: CGFloat = UIScreen.main.bounds.height
	
	public static let IPHONE_4: CGFloat = 480
	public static let IPHONE_5: CGFloat = 568
	public static let IPHONE_6: CGFloat = 667
	public static let IPHONE_6_Plus: CGFloat = 736
	
	public static let IS_IPHONE_4 = UIScreen.main.bounds.height == IPHONE_4
	public static let IS_IPHONE_5 = UIScreen.main.bounds.height == IPHONE_5
	public static let IS_IPHONE_6 = UIScreen.main.bounds.height == IPHONE_6
	public static let IS_IPHONE_6_Plus = UIScreen.main.bounds.height == IPHONE_6_Plus
}
