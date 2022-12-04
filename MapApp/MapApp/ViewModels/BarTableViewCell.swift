//
//  BarTableViewCell.swift
//  MapApp
//
//  Created by Matthew Morris on 6/24/22.
//

import UIKit

class BarTableViewCell: UITableViewCell {
    var title: UILabel!
    var address: UILabel!
    var distance: UILabel!
    var yelpLabel: UILabel!
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(cgColor: .init(red: 0.1, green: 0.1, blue: 0.11, alpha: 1))
        
        title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "Helvetica Neue", size: 20)
        title.textColor = .white
        
        distance = UILabel()
        distance.translatesAutoresizingMaskIntoConstraints = false
        distance.font = UIFont(name: "Helvetica Neue", size: 12)
        distance.textColor = .lightGray
        
        address = UILabel()
        address.translatesAutoresizingMaskIntoConstraints = false
        address.font = UIFont(name: "Helvetica Neue", size: 16)
        address.textColor = .white
        
        yelpLabel = UILabel()
        yelpLabel.translatesAutoresizingMaskIntoConstraints = false
        yelpLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        yelpLabel.text = "Powered by Yelp"
        yelpLabel.textColor = UIColor(cgColor: .init(gray: 0.5, alpha: 0.5))
        
        
        addSubview(title)
        addSubview(image)
        addSubview(distance)
        addSubview(address)
        addSubview(yelpLabel)
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//            image.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            image.widthAnchor.constraint(equalToConstant: 87),
            image.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            title.topAnchor.constraint(equalTo: image.topAnchor),
            title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            distance.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            distance.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            distance.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            address.topAnchor.constraint(equalTo: distance.bottomAnchor, constant: 10),
            address.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            address.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            yelpLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            yelpLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
