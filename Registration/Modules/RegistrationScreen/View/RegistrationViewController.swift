//
//  RegistrationViewController.swift
//  Registration
//
//  Created by Haidy Saeed on 26/01/2025.
//

import UIKit
import RxSwift
import RxCocoa

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var passwordStatusLbl: UILabel!
    
    var registrationViewModel: RegistrationViewModelProtocol = RegistrationViewModel()
    private let disposeBag = DisposeBag()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        registrationViewModel = RegistrationViewModel()
        registerBtn.isEnabled = false
        bindViewModel()
        registrationViewModel.applyRegistration()
        registrationViewModel.definePasswordStatus()
    }
    
    func bindViewModel() {
        nameTxt.rx.text.orEmpty.bind(to: registrationViewModel.nameValidation ).disposed(by: disposeBag)
        
        emailTxt.rx.text.orEmpty.bind(to: registrationViewModel.emailValidation ).disposed(by: disposeBag)
        
        passwordTxt.rx.text.orEmpty.bind(to: registrationViewModel.passwordValidation )
        registrationViewModel.passwordStatus
            .subscribe(onNext: { [weak self] status in
                guard let self = self else { return }
                switch status {
                case "Strong":
                    self.passwordStatusLbl.backgroundColor = .green
                    self.passwordStatusLbl.text = "Strong Password"
                case "Medium":
                    self.passwordStatusLbl.backgroundColor = .orange
                    self.passwordStatusLbl.text = "Medium Password"
                case "Weak":
                    self.passwordStatusLbl.backgroundColor = .red
                    self.passwordStatusLbl.text = "Weak Password"
                default:
                    self.passwordStatusLbl.backgroundColor = .clear
                    self.passwordStatusLbl.text = ""
                }
            })
        
            .disposed(by: disposeBag)
        
        registrationViewModel.enableRegistrationBtn
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { isValid in
                print("Button enabled: \(isValid)")
                self.registerBtn.isEnabled = isValid
            })
            .disposed(by: disposeBag)
        registerBtn.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.navigateToFilteredCities()
                self?.showSuccessAlert()
            })
            .disposed(by: disposeBag)
    }
    
    func navigateToFilteredCities() {
        let st = UIStoryboard(name: "Welcome", bundle: nil)
        let vc = st.instantiateViewController(identifier: "WelcomeScreenViewController") as! WelcomeScreenViewController
        vc.welcomeViewModel.welcomeText = self.nameTxt.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Registration was successful!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
