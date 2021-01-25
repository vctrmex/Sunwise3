//
//  AppNetworkUtils.swift
//  Sunwise
//
//  Created by victor manzanero on 20/01/21.
//

import Foundation
import SystemConfiguration

public class AppNetworkUtils{
    
    enum SaveNetworkData {
        case none
        case request
        case response
        case requestAndResponse
    }
    
    func loadJsonUrl(endpoint:String,jsonBody:[String:Any],completion: @escaping (Data?,HTTPURLResponse?,Error?) -> ()){
        loadJsonUrl(endpoint:endpoint,jsonBody:jsonBody,saveNetworkData:.none,completion:completion);
    }
    
    func loadJsonUrl(endpoint:String,jsonBody:[String:Any], saveNetworkData:SaveNetworkData, completion: @escaping (Data?,HTTPURLResponse?,Error?) -> ()){
       // print(endpoint);
        
        guard let url = URL(string: endpoint)
            else {
                let err = NSError(domain: "EndpontError", code: -401, userInfo: nil);
                
                if(saveNetworkData == .request || saveNetworkData == .requestAndResponse){
                    //Guarda los datos de la petición
                    let json = request2Json(from: jsonBody);
                    saveRequestData(endpoint: "request", data: json!)
                }
                
                completion(nil,nil,err);
                return;
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
            
            var request = URLRequest(url: url);
            //configuraciones extras para el consumo de api vctr
            /*request.httpMethod = "POST";
            request.httpBody = data;
            request.addValue("application/json", forHTTPHeaderField: "Content-Type");
            request.addValue("application/json", forHTTPHeaderField: "Accept");
            //request.addValue(AppData.authToken, forHTTPHeaderField: "Authentication-Token");
            request.addValue(AppConstans.API_KEY, forHTTPHeaderField: "api-key");
            request.addValue(AppConstans.API_SECRET, forHTTPHeaderField: "api-secret");
            if(AppConstans.tokenSeguridad != nil){
                //request.addValue((AppData.tokenSeguridad)!, forHTTPHeaderField: "authorization" );
                request.addValue((AppConstans.tokenSeguridad)!, forHTTPHeaderField: "token" );
            }*/
            
            //            print("Authentication-Token" , AppData.authToken);
            URLSession.shared.dataTask(with: request) { (data, response, err) in
                guard let data = data else {
                    //Si se solicita guardar los datos de la respuesta
                    if(saveNetworkData == .request || saveNetworkData == .requestAndResponse){
                    //Trata de leer el archivo guardado
                        let data = self.loadData(endpoint: endpoint)
                        //print(data,response)
                        if(data != nil){
                            print("Usando datos guardados ......")
                            //Si encuentra los datos guardados los regresa
                            completion(data, nil ,nil);
                            return
                        }
                    }
                    
                    let err = NSError(domain: "APIResponseError", code: -401, userInfo: nil);
                    completion(nil,nil,err);
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse{
                    //Si se solicita guardar los datos de la respuesta
                    if(saveNetworkData == .response || saveNetworkData == .requestAndResponse){
                        //guarda la respuesta en el disco
                        let newData = self.saveData(endpoint:endpoint, data:data)
                        completion(newData,httpResponse,nil);
                        //delegate.didNetworkFinishedHeaders(headers: httpResponse, option: option);
                    }else{
                        completion(data,httpResponse,nil);
                    }
                    
                    return;
                }
                
                
                
                completion(data, nil ,nil);
                }.resume();
            
        } catch let Err{
            completion(nil,nil, Err);
        }
        
    }
    
    public enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    public static func internetStatus()->ReachabilityStatus{
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
    
    // Convierte un arreglo del tipo String:Any a un string
    private func request2Json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    //Guarda el request en un archivo
    private func saveRequestData(endpoint:String, data:String){
        let lastIndex = endpoint.lastIndex(of: "/")!
        let file = (String(endpoint[lastIndex...])).replacingOccurrences(of: "/", with: "")
        
        
        let text = data //just a text
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            
            //writing
            do {
                try text.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            }
            catch {/* error handling here */}
        }
    }
    
    // Guarda la respuesta del servidor en un archivo
    private func saveData(endpoint:String, data:Data)->Data?{
        let lastIndex = endpoint.lastIndex(of: "/")!
        let file = (String(endpoint[lastIndex...])).replacingOccurrences(of: "/", with: "")
        
        
        let text = data //just a text
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            
            //writing
            do {
                try text.write(to: fileURL, options: .atomic)
            }
            catch {/* error handling here */}
            
            //reading
            do {
                let text2 = try Data(contentsOf: fileURL)
                return text2
            }
            catch let Err{
                print(Err)
            }
        }
        return nil
    }
    
    
    //CArga la respuesta del servidor de un archivo a un objeto
    private func loadData(endpoint:String)->Data?{
        let lastIndex = endpoint.lastIndexOf("/")!
        let file = (String(endpoint[lastIndex...])).replacingOccurrences(of: "/", with: "")
        
        print("Load file: ", file )
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            //reading
            do {
                let text2 = try Data(contentsOf: fileURL)
                return text2
            }
            catch {
                
            }
        }
        return nil
    }
    
    
    
    
    
}

