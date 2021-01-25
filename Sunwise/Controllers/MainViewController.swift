//
//  MainViewController.swift
//  Sunwise
//
//  Created by victor manzanero on 20/01/21.
//

import UIKit
import ZKCarousel

class MainViewController: UIViewController {
    
    @IBOutlet weak var carusel: ZKCarousel!
    let controller = AppController()
    var estrenos:Array<Estrenos> = []
    var calificada:Array<Calificadas> = []
    var popular:Array<Populares> = []
    @IBOutlet weak var colecctionTow: UICollectionView!
    @IBOutlet weak var colecctionOne: UICollectionView!
    let defaults = UserDefaults.standard
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCarousel()
        showLoadingScreen(vc: self, msg: "Estrenos")
        getEstrenos()
        getPapulares()
        getCalificadas()
        
       
    }
    
    
    func getEstrenos(){
        
        
        controller.getEstrenos(){ (res, err) in
            
            if(err == nil){
                
                guard let jsonArray = res as? [String: AnyObject] else {
                                                 return
                                             }
                guard let json = jsonArray["results"]!  as? [[String: AnyObject]] else {
                                                 return
                                             }
                
                self.setEstrenos(data: json)
                //self.setTable(data: json)
                                              
                

                return;
            }
           
        }
        
        
    }
    
    func getPapulares(){
        
        
        controller.getPopulares(){ (res, err) in
            
            if(err == nil){
                
                guard let jsonArray = res as? [String: AnyObject] else {
                                                 return
                                             }
                guard let json = jsonArray["results"]!  as? [[String: AnyObject]] else {
                                                 return
                                             }
                
                self.setPopulares(data: json)
                //self.setTable(data: json)
                                              
                

                return;
            }
           
        }
        
        
    }
    
    func getCalificadas(){
        
        
        controller.getCalificadas(){ (res, err) in
            
            if(err == nil){
                
                guard let jsonArray = res as? [String: AnyObject] else {
                                                 return
                                             }
                guard let json = jsonArray["results"]!  as? [[String: AnyObject]] else {
                                                 return
                                             }
               
                self.setCalificada(data: json)
                //self.setTable(data: json)
                                              
                

                return;
            }
           
        }
        
        
    }
    
    func setEstrenos(data:[[String:Any]]){
        
        for x in 0...4 {
            
            guard let nombre = data[x]["original_title"] as? String else { return }
            guard let imagen = data[x]["poster_path"] as? String else { return }
            guard let descripcion = data[x]["overview"] as? String else { return }
            guard let id = data[x]["id"] as? Double else { return }
            let estreno:Estrenos = Estrenos(imageName: imagen,name: nombre,descripcion: descripcion, id:"\(id)")
            self.estrenos.append(estreno)
        }
        
        self.setupCarousel()
        
    }
    
    
    
    private func setupCarousel() {
        
        
        var items:[ZKCarouselSlide] = []
        
        for item in self.estrenos {
            
            print(AppConstans.API_IMG + item.imageName)
            
            let url:URL = URL(string: AppConstans.API_IMG + item.imageName)!
            
            DispatchQueue.global(qos: .userInitiated).sync {
                
                let imagedata:NSData = NSData(contentsOf: url)!
                DispatchQueue.main.sync {
                    
                    let image = UIImage(data: imagedata as Data)
                    let slide = ZKCarouselSlide(image:image,
                                                title: item.name,
                                                description: item.descripcion)
                    items.append(slide)
                    
                    
                }
                
            }
            
            
            
            
        }
        
        self.carusel.slides = items
    
        self.carusel.interval = 1.5
        
        self.carusel.start()
        self.removeLoadingScreen()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    
        
        if segue.identifier == "detalles"{
            
            let controlador =  segue.destination as! DetallesViewController
            controlador.movie = sender 
            
        }
        
    }
    
    @IBAction func logOut(_ sender: Any) {
        
        let alert = UIAlertController(title: "Cerrar Sesion", message: "Esta apunto de cerrar sesion ¿Desea continuar?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Si", style: .default, handler: {(action: UIAlertAction) in
            
            self.defaults.set("", forKey: "username")
            self.defaults.set("",forKey: "pass")
            self.defaults.set(false,forKey:"ban")
            
            exit(0)
            
        }))

        self.present(alert, animated: true)
        
    }
    

}
