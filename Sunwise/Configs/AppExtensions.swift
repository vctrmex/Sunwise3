//
//  AppExtensions.swift
//  Sunwise
//
//  Created by victor manzanero on 25/01/21.
//
//
//  Extencions.swift
//  Sunwise
//
//  Created by victor manzanero on 20/01/21.
//

import Foundation
import UIKit

enum AppColors:String {
    case dark = "#3C1B32"
    case accent = "#7A145D"
    case base = "#16DDC1"
    case warning = "#EF1C90"
    case success = "#4EA6E9"
    case info = "#D5E519"
    case mainFont = "#1B3C38"
    case mainFontReverse = "#FFFFFF"
    case fbBtnColor = "#3B5999"
    case bkgdLight = "#000000"
}

enum AlertType {
    case error
    case success
    case warning
    case info
    
}


extension UIViewController {
    
    func showLoadingScreen(vc: UIViewController, msg: String){

        let overlay: UIView = {
            let view = UIView()
            view.tag = 101010;
            view.backgroundColor = UIColor(named: AppColors.bkgdLight.rawValue)
            return view
        }()

        let loadingContainer: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.clipsToBounds = true
            view.layer.cornerRadius = 3
            return view
        }()
        let loader: UIActivityIndicatorView = {
            let activityIndicator = UIActivityIndicatorView(style: .gray)
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = false
            activityIndicator.color = UIColor(named: AppColors.dark.rawValue)
            return activityIndicator
        }()

        let textLbl: UILabel = {
            let lbl = UILabel()
            lbl.text = msg
            lbl.textAlignment = .center
            lbl.tintColor = UIColor(named: AppColors.mainFont.rawValue)
            lbl.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            return lbl
        }()

        DispatchQueue.main.async {
            vc.view.addSubview(overlay)
            if #available(iOS 11.0, *) {
                overlay.anchor(top: vc.view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, right: vc.view.rightAnchor, paddingRight: 0, bottom: vc.view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0, left: vc.view.leftAnchor, paddingLeft: 0, height: nil, width: nil, centerX: nil, centerY: nil)
            } else {
                // Fallback on earlier versions
            }
            overlay.addSubview(loadingContainer)
            loadingContainer.anchor(top: nil, paddingTop: 0, right: nil, paddingRight: 0, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, height: 64, width: 256, centerX: overlay.centerXAnchor, centerY: overlay.centerYAnchor)
            loadingContainer.addSubview(loader)
            loader.center = CGPoint(x: 32, y: 32)
            loadingContainer.addSubview(textLbl)
            textLbl.anchor(top: loadingContainer.topAnchor, paddingTop: 8, right: loadingContainer.rightAnchor, paddingRight: 16, bottom: loadingContainer.bottomAnchor, paddingBottom: 8, left: loadingContainer.leftAnchor, paddingLeft: 48, height: nil, width: nil, centerX: nil, centerY: nil)
        }

    }

    func removeLoadingScreen(){
        DispatchQueue.main.async(execute: {()->Void in
            guard let myView = self.view.viewWithTag(101010) else { return }
            myView.removeFromSuperview()
        })
    }
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}

extension String {
    func indexOf(_ input: String,
                 options: String.CompareOptions = .literal) -> String.Index? {
        return self.range(of: input, options: options)?.lowerBound
    }
    
    func lastIndexOf(_ input: String) -> String.Index? {
        return indexOf(input, options: .backwards)
    }
    
    func lastIndexOfInt(of string: String) -> Int? {
        guard let index = range(of: string, options: .backwards) else { return nil }
        return self.distance(from: self.startIndex, to: index.lowerBound)
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, paddingTop: CGFloat,
                right: NSLayoutXAxisAnchor?, paddingRight: CGFloat,
                bottom: NSLayoutYAxisAnchor?, paddingBottom: CGFloat,
                left: NSLayoutXAxisAnchor?, paddingLeft: CGFloat,
                height: CGFloat?,
                width: CGFloat?,
                centerX: NSLayoutXAxisAnchor?,
                centerY: NSLayoutYAxisAnchor?
        ) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: paddingRight * -1).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom * -1).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
    
    func addShadow(opacity: Float, shadowRad: CGFloat, cornerRds: CGFloat){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = shadowRad
        self.layer.cornerRadius = cornerRds
        self.clipsToBounds = false
    }
}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView != self.colecctionTow{
            
            let p = self.popular[indexPath.row]
            
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PopularesCollectionViewCell
            
            let url:URL = URL(string: AppConstans.API_IMG + p.imageName)!
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                let imagedata:NSData = NSData(contentsOf: url)!
                DispatchQueue.main.async {
                    
                    let image = UIImage(data: imagedata as Data)
                    cell.image.image = image
                    cell.image.contentMode = .scaleAspectFit
                    
                    
                }
                
            }
            
            cell.nombre.text = p.name
            cell.descripcion.text = p.descripcion
            
            //This creates the shadows and modifies the cards a little bit
            cell.contentView.layer.cornerRadius = 4.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
            cell.layer.shadowRadius = 4.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
            
            return cell
        
        }else{
            
            
            
            let c = self.calificada[indexPath.row]
            
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! CalificadasCollectionViewCell
            
            let url:URL = URL(string: AppConstans.API_IMG + c.imageName)!
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                let imagedata:NSData = NSData(contentsOf: url)!
                
                DispatchQueue.main.async {
                    
                    let image = UIImage(data: imagedata as Data)
                    cell.image.image = image
                    cell.image.contentMode = .scaleAspectFit
                    
                }
                    
                    
                
                
            }
            
            cell.nombre.text = c.name
            cell.descripcion.text = c.descripcion
            
            //This creates the shadows and modifies the cards a little bit
            cell.contentView.layer.cornerRadius = 4.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
            cell.layer.shadowRadius = 4.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
             
             return cell
            
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == colecctionOne {
            
            performSegue(withIdentifier: "detalles", sender: self.popular[indexPath.row])
        
        }
        
        if collectionView == colecctionTow {
            
            performSegue(withIdentifier: "detalles", sender: self.calificada[indexPath.row])
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popular.count
    }
    
    func setPopulares(data:[[String:Any]]){
        
        for x in 0...4 {
            
            guard let nombre = data[x]["original_title"] as? String else { return }
            guard let imagen = data[x]["poster_path"] as? String else { return }
            guard let descripcion = data[x]["overview"] as? String else { return }
            guard let id = data[x]["id"] as? Double else { return }
            let popular:Populares = Populares(imageName: imagen,name: nombre,descripcion: descripcion,id: "\(id)")
            self.popular.append(popular)
        }
        DispatchQueue.main.async {
            self.colecctionOne.reloadData()
        }
        //self.setupCarousel()
        
    }
    
    func setCalificada(data:[[String:Any]]){
        
        for x in 0...4 {
            
            guard let nombre = data[x]["original_title"] as? String else { return }
            guard let imagen = data[x]["poster_path"] as? String else { return }
            guard let descripcion = data[x]["overview"] as? String else { return }
            guard let id = data[x]["id"] as? Double else { return }
            let calificada:Calificadas = Calificadas(imageName: imagen,name: nombre,descripcion: descripcion,id: "\(id)")
            self.calificada.append(calificada)
        }
        DispatchQueue.main.async {
            self.colecctionTow.reloadData()
        }
        //self.setupCarousel()
        
    }
    

    
}

