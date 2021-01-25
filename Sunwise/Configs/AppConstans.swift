//
//  Constants.swift
//  Sunwise
//
//  Created by victor manzanero on 20/01/21.
//

import Foundation

class AppConstans{
    
    // DEFINE EL AMBIENTE CON EL QUE FUNCIONARÁ
    static let API_ENVIROMENT = EnumEmviroment.DEV;
    static let API_KEY = "c5298cefc4a299c6f8f92477ec604c4b"
    static let API_SECRET = ""
    static var tokenSeguridad:String?
    
    
    static let API_YOUTUBE = "https://www.youtube.com/watch?v="
    private static let API_REST_URL_LOCAL   = ""
    private static let API_REST_URL_DEV     = "https://api.themoviedb.org/3/"
    //private static let API_REST_URL_DEV   = "";
    private static let API_REST_URL_QA      = "https://api.themoviedb.org/3/"
    private static let API_REST_OTHER = "https://api.themoviedb.org/3/"
    private static let API_REST_URL_PROD    = "";
    static let API_IMG = "https://image.tmdb.org/t/p/w500"
    static let API_REST_GET_POPULARES              = getAPI_URL() + "movie/popular?api_key="
    static let API_REST_GET_ESTRENOS               = getAPI_URL() + "movie/upcoming?api_key="
    static let API_REST_GET_MEJORCALIFICADAS       = getAPI_URL() + "movie/top_rated?api_key="
    static var API_REST_GET_VIDEO                  = getAPI_URL() + "movie/%%/videos?api_key="
    
    
    
    static func getAPI_URL()->String{
        switch(API_ENVIROMENT){
        case EnumEmviroment.QA:
            return API_REST_URL_QA
        case EnumEmviroment.DEV:
            return API_REST_URL_DEV;
        case EnumEmviroment.LOCAL:
            return API_REST_URL_LOCAL;
        case EnumEmviroment.PROD:
            return API_REST_URL_PROD;
        case EnumEmviroment.OTHER:
            return API_REST_OTHER
        }
    }
    
    enum EnumEmviroment {
        case QA
        case DEV
        case LOCAL
        case PROD
        case OTHER
    }
    
    static func getAPI_URL_NAME()->String{
        switch(API_ENVIROMENT){
        case EnumEmviroment.QA:
            return "QA"
        case EnumEmviroment.DEV:
            return "DEV";
        case EnumEmviroment.LOCAL:
            return "LOCAL";
        case EnumEmviroment.PROD:
            return "PROD"
        case EnumEmviroment.OTHER:
            return "OTHER"
        }
    }
    
    
}

