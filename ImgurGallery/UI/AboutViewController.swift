//
//  AboutViewController.swift
//  ImgurGallery
//
//  Created by Evgeniia Mikhailova on 11.10.18.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    private var reader = InfoDataReader()
    private var formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    func setup() {
        
        self.infoLabel.numberOfLines = 0
        self.infoLabel.textAlignment = .center
        self.infoLabel.lineBreakMode = .byWordWrapping
        self.formatter.dateFormat = "dd MMMM yyyy HH:mm:ss"
        
        self.infoLabel.text = self.buildString()
        
        if let date = self.reader.buildDate {
            self.infoLabel.text?.append("\n\n\(self.formatter.string(from: date))")
        }
        if let email = self.reader.email {
            self.emailButton.setTitle(email, for: .normal)
            self.emailButton.isHidden = false
        }
    }
    
    func buildString() -> String {
        return "Build \(self.reader.version ?? "") v\(self.reader.buildNumber ?? "0")"
    }
    
    @IBAction func sendEmail(_ sender: UIButton) {
        if let email = sender.titleLabel?.text, let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
