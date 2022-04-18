//
//  Api.swift
//  MobileNote
//
//  Created by mymac on 2022/4/14.
//

import Foundation
import Alamofire

public class Api {
    static var defaultApi = Api()
    static var baseUrl = "https://b.ismy.wang/"
    
    private init(){}
    
    func getDocFileInfo(id: String, callback : @escaping (DocFileInfo?) -> ()) {
        if (id.isEmpty) {
            callback(nil)
            return
        }
        
        let url = Api.baseUrl + docId2Url(id: id).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! + ".json"
        AF.request(url).response { response in
            if let data = response.data {
                do {
                    let decoder = JSONDecoder()
                    let docFileInfo = try decoder.decode(DocFileInfo.self, from: data)
                    callback(docFileInfo)
                } catch {
                    callback(nil)
                    debugPrint("Couldn't parse, \(error)")
                }
            }
        }
    }
    
    func getCategoryList(callback: @escaping ([Category]?) -> ()) {
        let url = Api.baseUrl + "category.json"
        AF.request(url).response { response in
            if let data = response.data {
                do {
                    let decoder = JSONDecoder()
                    let categoryList = try decoder.decode([Category].self, from: data)
                    callback(categoryList)
                } catch {
                    callback(nil)
                    debugPrint("Couldn't parse, \(error)")
                }
            }
        }
    }
    
    func getReviewList(callback: @escaping ([Review]?) -> ()) {
        let url = Api.baseUrl + "descCommitTimeDocList.json"
        AF.request(url).response { response in
            if let data = response.data {
                do {
                    let decoder = JSONDecoder()
                    let reviewList = try decoder.decode([[ReviewItem]].self, from: data).map {ReviewItem.toData($0)}
                    callback(reviewList)
                } catch {
                    callback(nil)
                    debugPrint("Couldn't parse, \(error)")
                }
            }
        }
    }
    
}
