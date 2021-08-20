//
//  Ocean+CarouselCell.swift
//  OceanComponents
//
//  Created by Vini on 20/08/21.
//

import OceanTokens

extension Ocean {
    public class CarouselCell: UICollectionViewCell {
        static let cellId = "CarouselCell"
        
        public var image: UIImage? {
            didSet {
                imageView.image = image
            }
        }
        
        private lazy var imageView: UIImageView = {
            UIImageView { imageView in
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.contentMode = .scaleAspectFit
            }
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupUI() {
            backgroundColor = .clear
            self.clipsToBounds = true
            self.ocean.radius.applyMd()
            
            addSubview(imageView)
        
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}