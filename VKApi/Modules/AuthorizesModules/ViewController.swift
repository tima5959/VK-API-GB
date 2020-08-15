//
//  ViewController.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 25.07.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit

final class AutorizateViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet var activityViews: [UIView]! {
        didSet {
            setCornerRadius(activityViews, radius: 25)
            activityViews.forEach { (view) in
                view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
        }
    }
    
    @IBOutlet weak var firstActivityView: UIView!
    @IBOutlet weak var secondActivityView: UIView!
    @IBOutlet weak var thirdActivityView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self,
                                                         action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        
        //      Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.​keyboardWasShown​),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        //      Второе -- когда она пропадает
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillBeHidden(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        setShadow(loginTextField)
        setShadow(passwordTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setAlphaAnimation(firstActivityView, 0.3)
        setAlphaAnimation(secondActivityView, 0.6)
        setAlphaAnimation(thirdActivityView, 0.9)
        
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 200
        animation.mass = 2
        animation.duration = 2
        animation.beginTime = CACurrentMediaTime() + 0.3
        animation.fillMode = CAMediaTimingFillMode.backwards
        passwordTextField.layer.add(animation, forKey: nil)
        loginTextField.layer.add(animation, forKey: nil)
    }
    
    @IBAction func entryButtonAction(_ sender: UIButton) {
        
    }
    
    // Переход по сигвею при определенных условиях
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let login = loginTextField.text
        let password = passwordTextField.text
        
        if login == "" && password == "" {
            return true
        } else {
            return false
        }
    }
    
    // Передача данных по сигвею
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // MARK: - OBJC Methods
    // Скрытие клавиатуры нажатием на экран
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    // Когда клавиатура появляется
    @objc func ​keyboardWasShown​(notification: Notification) {
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    // Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView = 0
        let contentInsets = UIEdgeInsets.zero
        // Устанавливаем отступ внизу UIScrollView, равный размеру клавиатуры
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}

