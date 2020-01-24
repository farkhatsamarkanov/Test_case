import Foundation
import RealmSwift
//MARK:- Realm DB classes
// class for "top headlines"
class ArticleCached : Object {
    @objc dynamic var author = ""
    @objc dynamic var title = ""
    @objc dynamic var articleDescription = ""
    @objc dynamic var url = ""
    @objc dynamic var urlToImage = ""
    @objc dynamic var publishedAt  = ""
    @objc dynamic var content = ""
    @objc dynamic var sourceName = ""
}
// class for "everything"
class EverythingCached : Object {
    @objc dynamic var author = ""
    @objc dynamic var title = ""
    @objc dynamic var articleDescription = ""
    @objc dynamic var url = ""
    @objc dynamic var urlToImage = ""
    @objc dynamic var publishedAt  = ""
    @objc dynamic var content = ""
    @objc dynamic var sourceName = ""
}
// class for "saved articles"
class ArticleSaved : Object {
    @objc dynamic var author = ""
    @objc dynamic var title = ""
    @objc dynamic var articleDescription = ""
    @objc dynamic var url = ""
    @objc dynamic var urlToImage = ""
    @objc dynamic var publishedAt  = ""
    @objc dynamic var content = ""
    @objc dynamic var sourceName = ""
}

