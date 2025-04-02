//
//  CardScannerVC.swift
//  CardScannerDemo
//
//  Created by Nirzar Gandhi on 13/01/25.
//

import UIKit

class CardScannerVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var cardInfoLabel: UILabel!
    @IBOutlet weak var startCardScannerBtn: UIButton!
    
    
    // MARK: -
    // MARK: - View init Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setControlsProperty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
    }
    
    fileprivate func setControlsProperty() {
        
        self.view.backgroundColor = .white
        
        // Card Info Label
        self.cardInfoLabel.backgroundColor = .clear
        self.cardInfoLabel.textColor = .black
        self.cardInfoLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        self.cardInfoLabel.textAlignment = .left
        self.cardInfoLabel.numberOfLines = 0
        self.cardInfoLabel.lineBreakMode = .byWordWrapping
        self.cardInfoLabel.text = ""
        
        // Start Card Scanner Button
        self.startCardScannerBtn.backgroundColor = .white
        self.startCardScannerBtn.titleLabel?.backgroundColor = .white
        self.startCardScannerBtn.setTitleColor(.black, for: .normal)
        self.startCardScannerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.startCardScannerBtn.setTitle("Start Card Scanner", for: .normal)
    }
}


// MARK: - Call Back
extension CardScannerVC {
    
    fileprivate func showNoPermissionAlert() {
        
        self.showAlert(style: .alert, title: "Oopps, No access", message: "Check settings and ensure the app has permission to use the camera.", actions: [UIAlertAction(title: "OK", style: .default, handler: { (_) in
            
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
            
        })])
    }
    
    fileprivate func showAlert(style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction]) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        alertController.view.tintColor = UIColor.black
        
        actions.forEach {
            alertController.addAction($0)
        }
        
        if style == .actionSheet && actions.contains(where: { $0.style == .cancel }) == false {
            alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}


// MARK: - Button Touch & Action
extension CardScannerVC {
    
    @IBAction func startCardScannerBtnTouch(_ sender: Any) {
        
        let scannerVC = SharkCardScanViewController(viewModel: CardScanViewModel(noPermissionAction: { [weak self] in
            
            self?.showNoPermissionAlert()
            
        }, successHandler: { (response) in
            self.cardInfoLabel.text = "Card Number: \(response.number) \n Expiry Date: \(response.expiry ?? "") \n Card Holder: \(response.holder ?? "")"
        }))
        
        self.present(scannerVC, animated: true, completion: nil)
    }
}
