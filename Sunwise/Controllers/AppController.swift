//
//  AppController.swift
//  Sunwise
//
//  Created by victor manzanero on 20/01/21.
//

import Foundation


class AppController{
    
    let appNetworkUtils = AppNetworkUtils();
    
    // MARK: Estrenos
    public func getEstrenos(completion: @escaping (Any,Error?)-> ()){
        let json = [String:Any]()
      
        
        let endpoint = AppConstans.API_REST_GET_ESTRENOS;
        let api_key = AppConstans.API_KEY
        let url = endpoint+api_key
        print("url: \(url)");
        
        
        appNetworkUtils.loadJsonUrl(endpoint: url, jsonBody: json) { (data, res, err) in
            print("getData ")
            if(err != nil){
                completion("null",err);
                return;
            }
            do{
                
                
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
          
                
                
                
                completion(json!,nil)
            }catch let jsonErr{
                //print(jsonErr);
                completion("null",jsonErr)
            }
        }
    }
    
    // MARK: POPULARES
    
    public func getPopulares(completion: @escaping (Any,Error?)-> ()){
        let json = [String:Any]()
      
        
        let endpoint = AppConstans.API_REST_GET_POPULARES;
        let api_key = AppConstans.API_KEY
        let url = endpoint+api_key
        print("url: \(url)");
        
        
        appNetworkUtils.loadJsonUrl(endpoint: url, jsonBody: json) { (data, res, err) in
            print("getData ")
            if(err != nil){
                completion("null",err);
                return;
            }
            do{
                
                
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
          
                
                
                
                completion(json!,nil)
            }catch let jsonErr{
                //print(jsonErr);
                completion("null",jsonErr)
            }
        }
    }
    
    // MARK: CALIFICADAS
    
    public func getCalificadas(completion: @escaping (Any,Error?)-> ()){
        let json = [String:Any]()
      
        
        let endpoint = AppConstans.API_REST_GET_MEJORCALIFICADAS;
        let api_key = AppConstans.API_KEY
        let url = endpoint+api_key
        print("url: \(url)");
        
        
        appNetworkUtils.loadJsonUrl(endpoint: url, jsonBody: json) { (data, res, err) in
            print("getData ")
            if(err != nil){
                completion("null",err);
                return;
            }
            do{
                
                
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
          
                
                
                
                completion(json!,nil)
            }catch let jsonErr{
                //print(jsonErr);
                completion("null",jsonErr)
            }
        }
    }
    
    // MARK: ID VIDEO
    
    public func getIDVideo(id:String,completion: @escaping (Any,Error?)-> ()){
        let json = [String:Any]()
      
       
       
        let endpoint = AppConstans.API_REST_GET_VIDEO.replacingOccurrences(of: "%%", with:id);
        let api_key = AppConstans.API_KEY
        let url = endpoint+api_key
        print("url: \(url)");
        
        
        appNetworkUtils.loadJsonUrl(endpoint: url, jsonBody: json) { (data, res, err) in
            print("getData ")
            if(err != nil){
                completion("null",err);
                return;
            }
            do{
                
                
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
          
                
                
                
                completion(json!,nil)
            }catch let jsonErr{
                //print(jsonErr);
                completion("null",jsonErr)
            }
        }
    }
    
    
}
