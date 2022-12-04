//
//  BarViewController.swift
//  MapApp
//
//  Created by Matthew Morris on 5/2/22.
//
import UIKit
import CoreLocation
import MapKit

class BarViewController: UIViewController {
    var id: String?
    
    var barName: UILabel!
    var barAddress: UILabel!
    var barNumber: UILabel!
    var infoView: UIView!
    var priceLabel: UILabel!
    var openLabel: UILabel!
    var yelpLabel: UILabel!
    
    private var photos: [String] = []
    
    lazy var urlButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "yelp_logo_dark_bg"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitleColor(UIColor.systemOrange, for: .normal)
        button.layer.zPosition = 1
        
        return button
    }()
    
    lazy var directionsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemOrange
        button.setTitle("Let's Go!", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        
        return button
    }()
    
    var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(BarCollectionViewCell.self, forCellWithReuseIdentifier: "CVcell")
        return cv
    }()
    
    
    //MARK: - Colors to be used for the color scheme
    let viewColor = "#3a3a3c"
    let textColor = "#eee9e8"
    let subviewColor = "#181818"
    let beerColor = "#c4671d"
    

    //MARK: - UI for the controller
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBarData()
        
        view.backgroundColor = UIColor(cgColor: .init(red: 0.1, green: 0.1, blue: 0.11, alpha: 1))
        
        barName = UILabel()
        barName.translatesAutoresizingMaskIntoConstraints = false
        barName.font = UIFont(name: "Helvetica Neue Bold", size: 25)
        barName.text = "Bar Data Not Found"
        barName.textColor = .white
    
        barAddress = UILabel()
        barAddress.translatesAutoresizingMaskIntoConstraints = false
        barAddress.font = UIFont(name: "HelveticaNeue", size: 18)
        barAddress.textColor = .white
        barAddress.lineBreakMode = .byWordWrapping
        barAddress.numberOfLines = 0
        
        barNumber = UILabel()
        barNumber.translatesAutoresizingMaskIntoConstraints = false
        barNumber.font = UIFont(name: "Helvetica Neue", size: 20)
        barNumber.textColor = .white
        addTopBorder(view: barNumber)
        
        photoCollectionView.backgroundColor = .none
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = UIFont(name: "Helvetica Neue", size: 20)
        priceLabel.textColor = .white
        addTopBorder(view: priceLabel)
        
        openLabel = UILabel()
        openLabel.translatesAutoresizingMaskIntoConstraints = false
        openLabel.font = UIFont(name: "Helvetica Neue", size: 18)
        
        yelpLabel = UILabel()
        yelpLabel.translatesAutoresizingMaskIntoConstraints = false
        yelpLabel.text = "Powered by Yelp"
        yelpLabel.font = UIFont(name: "Helvetica Neue", size: 16)
        yelpLabel.textColor = UIColor(cgColor: .init(gray: 0.5, alpha: 0.5))
        
        infoView = UIView()
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.isUserInteractionEnabled = true
        infoView.backgroundColor = UIColor(cgColor: .init(red: 0.13, green: 0.13, blue: 0.14, alpha: 1))
        infoView.layer.cornerRadius = 12
        infoView.layer.zPosition = -1
        
        view.addSubview(barName)
        view.addSubview(barAddress)
        view.addSubview(barNumber)
        view.addSubview(photoCollectionView)
        view.addSubview(priceLabel)
        view.addSubview(openLabel)
        view.addSubview(infoView)
        view.addSubview(directionsButton)
        view.addSubview(yelpLabel)
        view.addSubview(urlButton)
        
        NSLayoutConstraint.activate([
            barName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            barName.heightAnchor.constraint(equalToConstant: 40),
            barName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            barName.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95),
            
            openLabel.topAnchor.constraint(equalTo: barName.bottomAnchor, constant: 5),
            openLabel.leadingAnchor.constraint(equalTo: barName.leadingAnchor),
            openLabel.heightAnchor.constraint(equalToConstant: 20),
            openLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            yelpLabel.bottomAnchor.constraint(equalTo: photoCollectionView.topAnchor),
            yelpLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            photoCollectionView.topAnchor.constraint(equalTo: openLabel.bottomAnchor),
            photoCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            photoCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            infoView.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor, constant: 15),
            infoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95),
            infoView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25),
            
            barAddress.topAnchor.constraint(equalTo: infoView.topAnchor),
            barAddress.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            barAddress.heightAnchor.constraint(equalTo: infoView.heightAnchor, multiplier: 0.33),
            barAddress.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),

            barNumber.topAnchor.constraint(equalTo: barAddress.bottomAnchor),
            barNumber.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            barNumber.heightAnchor.constraint(equalTo: infoView.heightAnchor, multiplier: 0.33),
            barNumber.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            priceLabel.topAnchor.constraint(equalTo: barNumber.bottomAnchor),
            priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            priceLabel.heightAnchor.constraint(equalTo: infoView.heightAnchor, multiplier: 0.33),
            priceLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            urlButton.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 15),
            urlButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            urlButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            urlButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            directionsButton.topAnchor.constraint(equalTo: urlButton.bottomAnchor, constant: 25),
            directionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            directionsButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95),
            directionsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        
    }
        
        //MARK: - Functions to implement
    
    // API call function to get the data of the bar to populate in the BarViewController
    func loadBarData() {
        guard let id = id else {
            return
        }
        
        retrieveBarData(id: id) { response, error in
            if let response = response {
                
                DispatchQueue.main.async {
                    // Guard Statements
                    guard let url = response.url else { return }
                    guard let name = response.name else { return }
                    guard let latitude = response.latitude else { return }
                    guard let longitude = response.longitude else { return }
                    guard let phone = response.phone else { return }
                    guard let price = response.price else { return }
                    
                    // Changing the text of the labels
                    self.barName.text = name
                    self.barNumber.text = phone
                    self.barAddress.text = response.address
                    
                    // Code to get the buttons to work properly
                    let mapItem = MKMapItem(placemark: .init(coordinate: .init(latitude: latitude, longitude: longitude)))
                    mapItem.name = name
                    mapItem.phoneNumber = response.phone
                    mapItem.url = URL(string: url)
                    
                    
                    let openInMaps = UIAction(title: "Let's Go!") { (action) in
                        mapItem.openInMaps()
                    }
                    
                    let website = UIAction(title: url) { (action) in
                        if let url = URL(string: url) {
                            UIApplication.shared.open(url)
                        }
                    }
                    
                    self.urlButton.isUserInteractionEnabled = true
                    self.urlButton.addAction(website, for: .touchUpInside)
                    self.directionsButton.addAction(openInMaps, for: .touchUpInside)
                    
                    // If/Else statements for the labels that may or may not have information
                    if response.phone != nil {
                        self.barNumber.text = "Phone: \(phone)"
                    } else {
                        self.barNumber.text = "Phone: N/A"
                    }
                    
                    if response.price != nil {
                        self.priceLabel.text = "Price: \(price)"
                    } else {
                        self.priceLabel.text = "Price: N/A"
                    }
                    
                    if response.isOpen == true {
                        self.openLabel.text = "Now Open"
                        self.openLabel.textColor = .green
                    } else {
                        self.openLabel.text = "Currently Closed"
                        self.openLabel.textColor = .red
                    }
                    
                    // The photos in the photoCollectionView
                    for photo in response.photos {
                        self.photos.append(photo)
                        self.photoCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    
    func addTopBorder(view: UIView) {
        let thickness: CGFloat = 2.0
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width * 0.9, height: thickness)
        topBorder.backgroundColor = UIColor.darkGray.cgColor
        view.layer.addSublayer(topBorder)
    }
    
    func addBottomBorder(view: UIView) {
        let thickness: CGFloat = 2.0
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width * 0.9, height: thickness)
        topBorder.backgroundColor = UIColor.darkGray.cgColor
        view.layer.addSublayer(topBorder)
    }
    
}


//MARK: - Extensions

extension BarViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.5, height: collectionView.frame.height * 0.8)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVcell", for: indexPath) as! BarCollectionViewCell
                
        let fileUrl = URL(string: photos[indexPath.row])
        cell.backGround.load(url: fileUrl!)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PhotoViewController()
        vc.modalPresentationStyle = .formSheet
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true) {
            let fileUrl = URL(string: self.photos[indexPath.row])
            vc.imageView.load(url: fileUrl!)
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }

        return nil
    }
}
