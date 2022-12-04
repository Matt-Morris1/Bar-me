//
//  BarCollectionViewCell.swift
//  MapApp
//
//  Created by Matthew Morris on 5/4/22.
//
import Foundation
import UIKit

class BarCollectionViewCell: UICollectionViewCell {
    
    let backGround: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(backGround)
        
        backGround.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        backGround.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        backGround.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        backGround.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
}
