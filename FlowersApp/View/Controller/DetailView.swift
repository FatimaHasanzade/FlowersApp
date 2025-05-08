//
//  DetailView.swift
//  FlowersApp
//
//  Created by Fatima Hasanzade on 05.05.25.
//

import UIKit
import SnapKit

class DetailView: UIView {
    
    // MARK: - Properties
    lazy var labelTitle: UILabel = {
        let labelTitle = UILabel()
        labelTitle.textAlignment = .left
        labelTitle.font = .systemFont(ofSize: 18, weight: .bold)
        return labelTitle
    }()
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "sun.max")
        return imageView
    }()
    
    lazy var imageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.applyShadow()
        return view
    }()
    
    
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
    
    // MARK: - Override Methods
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
    
}

extension DetailView {
    
    // MARK: - Setup Methods
    private func setupView() {
        addSubViews(labelTitle,imageContainer)
        imageContainer.addSubview(imageView)
    }

    // MARK: - Styling Methods
    private func style() {
        backgroundColor = .white
        
    }
    
    // MARK: - Layout Methods
    private func layout() {
        translatesAutoresizingMaskIntoConstraints = false
        imageContainer.snp.makeConstraints { make in
                    make.top.equalTo(safeAreaLayoutGuide.snp.top)
                    make.leading.trailing.equalToSuperview()
                    make.height.equalTo(300)
                }
                
                imageView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                
                labelTitle.snp.makeConstraints { make in
                    make.top.equalTo(imageContainer.snp.bottom).offset(30)
                    make.leading.equalToSuperview().offset(30)
                    make.trailing.equalToSuperview().inset(30)
                }
    }

    
}

