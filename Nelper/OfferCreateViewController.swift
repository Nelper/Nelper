//
//  OfferViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-06-24.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit

class OfferCreateViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func onDoneClicked(sender: UIBarButtonItem) {
    
  }
  
  @IBAction func onCancelClicked(sender: UIBarButtonItem) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}

