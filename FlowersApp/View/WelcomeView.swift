//
//  WelcomeView.swift
//  FlowersApp
//
//  Created by Fatime on 04.05.25.
//

import UIKit
import SnapKit

class WelcomeView:UIView {
    
    var didTapStart:(()->Void)?
    
    // MARK: - UI Elements
    private lazy var backgroundImage:UIImageView = {
        let imageView = UIImageView(image: Images.Welcome.backgroundImage)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var logoImage:UIImageView = {
        let imageView = UIImageView(image: Images.Welcome.logo)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel:UILabel = {
       let label = UILabel()
        label.textColor = UIColor(red: 1.3, green: 0.75, blue: 0.8, alpha: 1.0)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 42,weight: .bold)
        label.numberOfLines = 0
        label.text = "Welcome to Flowers App"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17,weight: .medium)
        label.text = "Find your favorite flower"
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var startButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemTeal
        button.setTitle("Get Started", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 17)!
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Actions
    @objc func startButtonTapped() {
        didTapStart?()
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        style()
        layout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
    
    
}


extension WelcomeView {
    
    // MARK: - Setup and Layout
    private func setupView() {
        addSubViews(backgroundImage,logoImage, titleLabel, descriptionLabel, startButton)
    }

    private func style() {
        backgroundColor = .clear
        
    }
    private func layout() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
        startButton.snp.makeConstraints { make in
                    make.height.equalTo(67)
                    make.leading.equalToSuperview().offset(30)
                    make.trailing.equalToSuperview().inset(30)
                    make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-30)
                }

                descriptionLabel.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.bottom.equalTo(startButton.snp.top).offset(-40)
                }

                titleLabel.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(30)
                    make.trailing.equalToSuperview().inset(30)
                    make.bottom.equalTo(descriptionLabel.snp.top).offset(-18)
                }

                logoImage.snp.makeConstraints { make in
                    make.width.height.equalTo(100)
                    make.centerX.equalToSuperview()
                    make.bottom.equalTo(titleLabel.snp.top).offset(-20)
                }
    }


}
