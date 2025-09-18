//
//  SplashViewController.swift
//  kioskApp
//
//  Created by 박혜연 on 9/17/25.
//

import UIKit
import SnapKit

final class SplashViewController: UIViewController {
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "kioscornLogo")
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        view.backgroundColor = UIColor(named: "#FDF6F6")
        view.addSubview(logoImage)
        logoImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(178)
            make.height.equalTo(129)
        }
    }

}
