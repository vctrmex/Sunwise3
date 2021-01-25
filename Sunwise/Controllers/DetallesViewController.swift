//
//  DetallesViewController.swift
//  Sunwise
//
//  Created by victor manzanero on 21/01/21.
//

import UIKit
import SafariServices

class DetallesViewController: UIViewController, SFSafariViewControllerDelegate{
    
    var movie:Any?
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var texto: UITextView!
    let controller = AppController()
    var idVideo:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //guard let obj = movie as? Populares else { return }
        
        if let obj = movie as? Populares{
        let url:URL = URL(string: AppConstans.API_IMG + obj.imageName)!
    
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                let imagedata:NSData = NSData(contentsOf: url)!
                
                DispatchQueue.main.async {
                    
                    let image = UIImage(data: imagedata as Data)
                    self.image.image = image
                    self.texto.text = obj.descripcion
                    self.idVideo = obj.id
                    
                }
                
            }
        }
        if let obj = movie as? Calificadas{
        let url:URL = URL(string: AppConstans.API_IMG + obj.imageName)!
    
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                let imagedata:NSData = NSData(contentsOf: url)!
                
                DispatchQueue.main.async {
                    
                    let image = UIImage(data: imagedata as Data)
                    self.image.image = image
                    self.texto.text = obj.descripcion
                    self.idVideo = obj.id
                    
                }
                
            }
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func showTrailer(_ sender: Any) {
        
        getKey()
        
        
    }
    
    private func openLink(_ stringURL: String) {
            guard let url = URL(string: stringURL) else {
                // We should handle an invalid stringURL
                return
            }

            // Present SFSafariViewController
            let safariVC = SFSafariViewController(url: url)
            safariVC.delegate = self
            present(safariVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Obtengo llave
    
    func getKey()  {
        
        
        controller.getIDVideo(id: self.idVideo){ (res, err) in
            
            if(err == nil){
                
                guard let jsonArray = res as? [String: Any] else {
                                                 return
                                             }
                
                //print(jsonArray["results"]!)
                guard let json = jsonArray["results"]!  as? [[String: Any]] else {
                                                 return
                                             }
                //print(json[0]["key"]!)
                //self.setTable(data: json)
                if json.count > 0 {
                    
                    guard let id = json[0]["key"] as? String else { return }
                    DispatchQueue.main.async {
                        
                        self.openLink(AppConstans.API_YOUTUBE + id)
                        print(AppConstans.API_YOUTUBE + id)
                        
                    }
                    
                }
               

                
            }
           
        }
        
        
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
        
    }


}
