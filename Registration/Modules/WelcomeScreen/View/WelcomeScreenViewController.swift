//
//  WelcomeScreenViewController.swift
//  Registration
//
//  Created by Haidy Saeed on 26/01/2025.
//

import UIKit

class WelcomeScreenViewController: UIViewController {
    
    @IBOutlet weak var welcomeLbl: UILabel!
    var welcomeViewModel : WelcomeViewModelProtocol = WelcomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLbl.text =  "Welcome " + welcomeViewModel.welcomeText
    }
}
