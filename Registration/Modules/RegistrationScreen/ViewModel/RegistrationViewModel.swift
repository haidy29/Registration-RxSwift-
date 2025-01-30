//
//  Untitled.swift
//  Registration
//
//  Created by Haidy Saeed on 26/01/2025.
//
import RxSwift
import RxCocoa

protocol RegistrationViewModelProtocol {
    
    var nameValidation: PublishSubject<String> { get }
    var emailValidation: PublishSubject<String> { get }
    var passwordValidation: PublishSubject<String> { get }
    var enableRegistrationBtn: PublishSubject<Bool> { get }
    var passwordStatus: PublishSubject<String> { get }
    
    func applyRegistration()
    func definePasswordStatus()
}

class RegistrationViewModel : RegistrationViewModelProtocol{
    
    var nameValidation: PublishSubject<String> = PublishSubject()
    var passwordValidation: PublishSubject<String> = PublishSubject()
    var emailValidation: PublishSubject<String> = PublishSubject()
    var enableRegistrationBtn: PublishSubject<Bool> = PublishSubject()
    var passwordStatus: PublishSubject<String> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    func applyRegistration(){
        Observable.combineLatest(
            nameValidation.map{$0.count >= 20 &&  !$0 .isEmpty}
            , passwordValidation.map({$0.count >= 6 &&  !$0 .isEmpty})
            , emailValidation.map{$0.contains("@") &&  !$0 .isEmpty})
        { nameValid, emailValid, passwordValid in
            let isValid = nameValid && emailValid && passwordValid
            return isValid
        }
        .bind(to: enableRegistrationBtn)
        .disposed(by: disposeBag)
    }
    
    func definePasswordStatus(){
        passwordValidation.subscribe(onNext: { [weak self] password in
            guard let self = self else { return }
            if password.count >= 12{
                self.passwordStatus.onNext("Strong")
            }else if password.count >= 10{
                self.passwordStatus.onNext("Medium")
            }else if password.count >= 6{
                self.passwordStatus.onNext("Weak")
            }else{
                self.passwordStatus.onNext("")
            }
        }) .disposed(by: disposeBag)
        
    }
}
