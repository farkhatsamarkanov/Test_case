import Foundation
import UIKit
class NewsProvider {
    let realmOps = RealmOps()
    let userInfo = ["key":"value"]
    let networkDataFetcher = NetworkDataFetcher()
    // Temporary storage variables
    var webResponse: [Article] = []
    var anotherWebResponse: [Article] = []
    // API Key
    let apiKey = "e65ee0938a2a43ebb15923b48faed18d"
    var timer: Timer?
    // Cache for image downloading
    var imageCache = NSCache<NSString, UIImage>()
    
    private func sendNotification() {
        NotificationCenter.default.post(name: Constants.notificationName, object: nil, userInfo: userInfo)
    }
    private func sendAnotherNotification() {
        NotificationCenter.default.post(name: Constants.everythingNotificationName, object: nil, userInfo: userInfo)
    }
    // Timer settings
    func reloadTimer(timerPageSize : Int) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
            self.generateArticles(givenPageSize: timerPageSize)
            print("timer fired")
        }
    }
    
    func urlBuilder (apiKey : String, pageSize : Int) -> String {
        let result = "https://newsapi.org/v2/top-headlines?category=technology&pageSize=\(pageSize)&country=us&apiKey=\(apiKey)"
        return result
    }
    
    func anotherUrlBuilder (apiKey : String, pageSize : Int) -> String {
        let result = "https://newsapi.org/v2/everything?q=technology&pageSize=\(pageSize)&language=en&apiKey=\(apiKey)"
        return result
    }
    
    func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
        } else {
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
            let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard error == nil,
                    data != nil,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200,
                    let `self` = self else {
                        return
                }
                guard let image = UIImage(data: data!) else { return }
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            dataTask.resume()
        }
    }
    
    //MARK:- Generating articles for top headlines
    func generateArticles (givenPageSize : Int) {
        self.networkDataFetcher.fetchData(urlString: urlBuilder(apiKey: self.apiKey, pageSize: givenPageSize)) { (webResponse) in
            self.webResponse = webResponse.articles
            DispatchQueue.main.async {
                self.realmOps.saveData(articles: self.webResponse)
                self.sendNotification()
            }
        }
    }
    //MARK:- Generating articles for "everything" endpoint
    func generateEverything (givenPageSize : Int) {
        self.networkDataFetcher.fetchData(urlString: anotherUrlBuilder(apiKey: self.apiKey, pageSize: givenPageSize)) { (webResponse) in
            self.anotherWebResponse = webResponse.articles
            DispatchQueue.main.async {
                self.realmOps.saveEverything(articles: self.anotherWebResponse)
                self.sendAnotherNotification()
            }
        }
    }
    
}
