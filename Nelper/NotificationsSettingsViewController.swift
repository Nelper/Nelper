//
//  NotificationsSettingsViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-10-14.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

class NotificationsSettingsViewController: UIViewController {
	
	
	private var navBar: NavBar!
	var contentView: UIView!
	
	var emailNotContainer: DefaultContainerView!
	
	var t1Label: UILabel!
	var t1EmailMeWhen: UILabel!
	var t1FirstEvent: UILabel!
	var t1FirstSwitch: UISwitch!
	var t1SecondEvent: UILabel!
	var t1SecondSwitch: UISwitch!
	
	var t2Label: UILabel!
	var t2EmailMeWhen: UILabel!
	var t2FirstEvent: UILabel!
	var t2FirstSwitch: UISwitch!
	var t2SecondEvent: UILabel!
	var t2SecondSwitch: UISwitch!
	
	var t3Label: UILabel!
	var t3SendMe: UILabel!
	var t3FirstEvent: UILabel!
	var t3FirstSwitch: UISwitch!
	
	let kPadding: Int = 20
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		createView()
		adjustUI()
	}
	
	func createView() {
		
		///NAVBAR
		let navBar = NavBar()
		self.navBar = navBar
		self.view.addSubview(self.navBar)
		self.navBar.setTitle("Notification Settings")
		self.navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
		let contentView = UIView()
		self.contentView = contentView
		self.view.addSubview(contentView)
		self.contentView.backgroundColor = whiteBackground
		self.contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.navBar.snp_bottom)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
		}
		
		///EMAIL NOTIFICATIONS
		let emailNotContainer = DefaultContainerView()
		self.emailNotContainer = emailNotContainer
		self.contentView.addSubview(self.emailNotContainer)
		self.emailNotContainer.containerTitle = "Email Notifications"
		self.emailNotContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.contentView.snp_top).offset(self.kPadding)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
		}
		
		///TASK POSTER
		let t1Label = UILabel()
		self.t1Label = t1Label
		self.emailNotContainer.contentView.addSubview(self.t1Label)
		self.t1Label.text = "Task Poster"
		self.t1Label.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.t1Label.textColor = redPrimary
		self.t1Label.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.emailNotContainer.contentView.snp_top).offset(15)
			make.left.equalTo(self.emailNotContainer.snp_left).offset(self.kPadding)
		}
		
		let t1EmailMeWhen = UILabel()
		self.t1EmailMeWhen = t1EmailMeWhen
		self.emailNotContainer.contentView.addSubview(self.t1EmailMeWhen)
		self.t1EmailMeWhen.text = "Email me when"
		self.t1EmailMeWhen.font = UIFont(name: "Lato-Regular", size: kText15)
		self.t1EmailMeWhen.textColor = blackPrimary
		self.t1EmailMeWhen.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.t1Label.snp_bottom).offset(15)
			make.left.equalTo(self.t1Label.snp_left)
		}
		
		let t1FirstEvent = UILabel()
		self.t1FirstEvent = t1FirstEvent
		self.emailNotContainer.contentView.addSubview(self.t1FirstEvent)
		self.t1FirstEvent.text = "A Nelper applies for my task"
		self.t1FirstEvent.font = UIFont(name: "Lato-Light", size: kText15)
		self.t1FirstEvent.textColor = blackPrimary
		self.t1FirstEvent.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.t1EmailMeWhen.snp_bottom).offset(kPadding)
			make.left.equalTo(self.t1Label.snp_left)
		}
		
		let t1FirstSwitch = UISwitch()
		self.t1FirstSwitch = t1FirstSwitch
		self.emailNotContainer.contentView.addSubview(self.t1FirstSwitch)
		self.t1FirstSwitch.on = true
		self.t1FirstSwitch.onTintColor = redPrimary
		self.t1FirstSwitch.tintColor = grayDetails
		self.t1FirstSwitch.thumbTintColor = whitePrimary
		self.t1FirstSwitch.setOn(true, animated: false)
		self.t1FirstSwitch.addTarget(self, action: "t1FirstSwitchChanged:", forControlEvents: .ValueChanged)
		self.t1FirstSwitch.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(self.emailNotContainer.snp_right).offset(-self.kPadding)
			make.centerY.equalTo(self.t1FirstEvent.snp_centerY)
		}
		
		self.t1FirstEvent.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(self.t1FirstSwitch.snp_left).offset(-15)
		}
		
		let t1SecondEvent = UILabel()
		self.t1SecondEvent = t1SecondEvent
		self.emailNotContainer.contentView.addSubview(self.t1SecondEvent)
		self.t1SecondEvent.text = "My Nelper requests their payment"
		self.t1SecondEvent.font = UIFont(name: "Lato-Light", size: kText15)
		self.t1SecondEvent.textColor = blackPrimary
		self.t1SecondEvent.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.t1FirstEvent.snp_bottom).offset(kPadding)
			make.left.equalTo(self.t1FirstEvent.snp_left)
		}
		
		let t1SecondSwitch = UISwitch()
		self.t1SecondSwitch = t1SecondSwitch
		self.emailNotContainer.contentView.addSubview(self.t1SecondSwitch)
		self.t1SecondSwitch.on = true
		self.t1SecondSwitch.onTintColor = redPrimary
		self.t1SecondSwitch.tintColor = grayDetails
		self.t1SecondSwitch.thumbTintColor = whitePrimary
		self.t1SecondSwitch.setOn(true, animated: false)
		self.t1SecondSwitch.addTarget(self, action: "t1SecondSwitchChanged:", forControlEvents: .ValueChanged)
		self.t1SecondSwitch.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(self.t1FirstSwitch.snp_right)
			make.centerY.equalTo(self.t1SecondEvent.snp_centerY)
		}
		
		self.t1SecondEvent.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(self.t1FirstEvent.snp_right)
		}
		
		///NELPER
		let t2Label = UILabel()
		self.t2Label = t2Label
		self.emailNotContainer.contentView.addSubview(self.t2Label)
		self.t2Label.text = "Task Poster"
		self.t2Label.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.t2Label.textColor = redPrimary
		self.t2Label.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.t1SecondEvent.snp_bottom).offset(kPadding + 10)
			make.left.equalTo(self.emailNotContainer.snp_left).offset(self.kPadding)
		}
		
		let t2EmailMeWhen = UILabel()
		self.t2EmailMeWhen = t2EmailMeWhen
		self.emailNotContainer.contentView.addSubview(self.t2EmailMeWhen)
		self.t2EmailMeWhen.text = "Email me when"
		self.t2EmailMeWhen.font = UIFont(name: "Lato-Regular", size: kText15)
		self.t2EmailMeWhen.textColor = blackPrimary
		self.t2EmailMeWhen.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.t2Label.snp_bottom).offset(15)
			make.left.equalTo(self.t2Label.snp_left)
		}
		
		let t2FirstEvent = UILabel()
		self.t2FirstEvent = t2FirstEvent
		self.emailNotContainer.contentView.addSubview(self.t2FirstEvent)
		self.t2FirstEvent.text = "My task application status changes"
		self.t2FirstEvent.font = UIFont(name: "Lato-Light", size: kText15)
		self.t2FirstEvent.textColor = blackPrimary
		self.t2FirstEvent.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.t2EmailMeWhen.snp_bottom).offset(kPadding)
			make.left.equalTo(self.t2Label.snp_left)
		}
		
		let t2FirstSwitch = UISwitch()
		self.t2FirstSwitch = t2FirstSwitch
		self.emailNotContainer.contentView.addSubview(self.t2FirstSwitch)
		self.t2FirstSwitch.on = true
		self.t2FirstSwitch.onTintColor = redPrimary
		self.t2FirstSwitch.tintColor = grayDetails
		self.t2FirstSwitch.thumbTintColor = whitePrimary
		self.t2FirstSwitch.setOn(true, animated: false)
		self.t2FirstSwitch.addTarget(self, action: "t2FirstSwitchChanged:", forControlEvents: .ValueChanged)
		self.t2FirstSwitch.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(self.emailNotContainer.snp_right).offset(-self.kPadding)
			make.centerY.equalTo(self.t2FirstEvent.snp_centerY)
		}
		
		self.t2FirstEvent.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(self.t2FirstSwitch.snp_left).offset(-15)
		}
		
		let t2SecondEvent = UILabel()
		self.t2SecondEvent = t2SecondEvent
		self.emailNotContainer.contentView.addSubview(self.t2SecondEvent)
		self.t2SecondEvent.text = "I receive a payment"
		self.t2SecondEvent.font = UIFont(name: "Lato-Light", size: kText15)
		self.t2SecondEvent.textColor = blackPrimary
		self.t2SecondEvent.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.t2FirstEvent.snp_bottom).offset(kPadding)
			make.left.equalTo(self.t2FirstEvent.snp_left)
		}
		
		let t2SecondSwitch = UISwitch()
		self.t2SecondSwitch = t2SecondSwitch
		self.emailNotContainer.contentView.addSubview(self.t2SecondSwitch)
		self.t2SecondSwitch.on = true
		self.t2SecondSwitch.onTintColor = redPrimary
		self.t2SecondSwitch.tintColor = grayDetails
		self.t2SecondSwitch.thumbTintColor = whitePrimary
		self.t2SecondSwitch.setOn(true, animated: false)
		self.t2SecondSwitch.addTarget(self, action: "t2SecondSwitchChanged:", forControlEvents: .ValueChanged)
		self.t2SecondSwitch.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(self.t2FirstSwitch.snp_right)
			make.centerY.equalTo(self.t2SecondEvent.snp_centerY)
		}
		
		self.t2SecondEvent.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(self.t2FirstEvent.snp_right)
		}
		
		self.emailNotContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self.t2SecondEvent.snp_bottom).offset(self.kPadding)
		}
	}
	
	func adjustUI() {
		
		//NAVBAR
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.closeButton = previousBtn
		self.contentView.backgroundColor = whiteBackground
	}
	
	//MARK: ACTIONS
	func backButtonTapped(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
		view.endEditing(true) // dissmiss keyboard without delay
	}
	
	func t1FirstSwitchChanged(sender: UISwitch) {
		
	}
	
	func t1SecondSwitchChanged(sender: UISwitch) {
		
	}
	
	func t2FirstSwitchChanged(sender: UISwitch) {
		
	}
	
	func t2SecondSwitchChanged(sender: UISwitch) {
		
	}
}