//
//  SecondViewController.swift
//  GCDApp
//
//  Created by Фаддей Гусаров on 26.01.2022.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    fileprivate var imageURL: URL?
    fileprivate var semaphore = DispatchSemaphore(value: 0)
    fileprivate var image: UIImage? {
        get {
            return self.imageView?.image
        }

        set {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.imageView.image = newValue
            self.imageView.sizeToFit()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
        delay(3) {
            self.loginAlert()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animate()
    }

    fileprivate func delay(_ delay: Int, closure: @escaping () -> ()) {
        
        self.semaphore.signal()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            closure()
        }
        self.semaphore.wait()
    }
    
    fileprivate func animate() {
        self.semaphore.signal()
        let queue = DispatchQueue(label: "queue", qos: .utility, attributes: .concurrent)
        queue.sync {
            UIView.animate(withDuration: 3) {
                self.imageView.alpha = 0
            }
            UIView.animate(withDuration: 3) {
                self.imageView.alpha = 1
            }
            self.semaphore.wait()
        }
    }

    fileprivate func loginAlert() {

        let alertController = UIAlertController(title: "Зарегистрированы?", message: "Введите логин и пароль", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        alertController.addTextField { (usernameTextField) in
            usernameTextField.placeholder = "Введите логин"
        }
        alertController.addTextField { (userPasswordTextField) in
            userPasswordTextField.placeholder = "Введите пароль"
            userPasswordTextField.isSecureTextEntry = true
        }

        self.present(alertController, animated: true, completion: nil)
    }

    fileprivate func fetchImage() {
        
        self.semaphore.signal()

        self.imageURL = URL(string: "https://sun9-11.userapi.com/impg/eKjkfC7iPQo3BR1YUU5540OrjUHddiYJXQrysA/9IZEBbll0kA.jpg?size=750x719&quality=96&sign=2dc4ee665044ec9a634f712ab2c62266&type=album")
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()

        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            guard let url = self.imageURL, let imageData = try? Data(contentsOf: url) else { return }
            self.semaphore.wait()

            DispatchQueue.main.async {
                self.image = UIImage(data: imageData)
            }
        }

    }
}
