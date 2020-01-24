import Foundation
import RealmSwift
//MARK:- Realm DB operations
class RealmOps {
    //MARK:- Saving to DB
    //top headlines
    func saveData(articles:[Article]) {
        do {
            let realm = try! Realm()
            try realm.write {
                let result = realm.objects(ArticleCached.self)
                realm.delete(result)
                let articlesRealm = articleConverter(articles: articles)
                for i in articlesRealm {
                    realm.add(i)
                }
            }
        } catch {
            print("Error while writing to Realm: \(error)")
        }
    }
    //everything
    func saveEverything(articles:[Article]) {
        do {
            let realm = try! Realm()
            try realm.write {
                let result = realm.objects(EverythingCached.self)
                realm.delete(result)
                let articlesRealm = anotherArticleConverter(articles: articles)
                for i in articlesRealm {
                    realm.add(i)
                }
            }
        } catch {
            print("Error while writing to Realm: \(error)")
        }
    }
    //everything to bookmarks
    func saveEverythingToBookmark (article: EverythingCached) {
        do {
            let realm = try! Realm()
            try realm.write {
                
                let articleRealm = everythingToSaveConverter(article: article)
                
                realm.add(articleRealm)
                print("saved ever")
            }
        } catch {
            print("Error while writing to Realm: \(error)")
        }
    }
    //top headlines to bookmarks
    func saveArticle(article: ArticleCached) {
        do {
            let realm = try! Realm()
            try realm.write {
                let articleRealm = articleToSaveConverter(article: article)
                realm.add(articleRealm)
                print("saved article")
            }
        } catch {
            print("Error while writing to Realm: \(error)")
        }
    }
    //MARK:- reading from DB classes
    // reading top headlines
    func readData() -> [ArticleCached] {
        var articles: [ArticleCached] = []
        do {
            let realm = try Realm()
            let result = realm.objects(ArticleCached.self)
            for article in result {
                let articleModel = article
                articles.append(articleModel)
            }
        } catch {
            print("Error while reading data from Realm: \(error)")
        }
        return articles
    }
    // reading everything
    func readEverything() -> [EverythingCached] {
        var articles: [EverythingCached] = []
        do {
            let realm = try Realm()
            let result = realm.objects(EverythingCached.self)
            for article in result {
                let articleModel = article
                articles.append(articleModel)
            }
        } catch {
            print("Error while reading data from Realm: \(error)")
        }
        return articles
    }
    //reading saved articles
    func readSaved() -> [ArticleSaved] {
        var articles: [ArticleSaved] = []
        do {
            let realm = try Realm()
            let result = realm.objects(ArticleSaved.self)
            for article in result {
                let articleModel = article
                articles.append(articleModel)
            }
        } catch {
            print("Error while reading data from Realm: \(error)")
        }
        return articles
    }
    //MARK:- Convertign network data to cached data
    func articleToSaveConverter(article: ArticleCached) -> ArticleSaved {
        let articleRealm = ArticleSaved()
        articleRealm.author = article.author
        articleRealm.title = article.title
        articleRealm.articleDescription  = article.articleDescription
        articleRealm.url = article.url
        articleRealm.urlToImage = article.urlToImage
        articleRealm.publishedAt = article.publishedAt
        articleRealm.content = article.content
        articleRealm.sourceName  = article.sourceName
        return articleRealm
    }
    
    func everythingToSaveConverter(article: EverythingCached) -> ArticleSaved {
        let articleRealm = ArticleSaved()
        articleRealm.author = article.author
        articleRealm.title = article.title
        articleRealm.articleDescription  = article.articleDescription
        articleRealm.url = article.url
        articleRealm.urlToImage = article.urlToImage
        articleRealm.publishedAt = article.publishedAt
        articleRealm.content = article.content
        articleRealm.sourceName  = article.sourceName
        return articleRealm
    }
    
    func articleConverter(articles: [Article]) -> [ArticleCached] {
        var articlesRealm: [ArticleCached] = []
        for article in articles {
            let articleRealm = ArticleCached()
            articleRealm.author = article.author ?? ""
            articleRealm.title = article.title ?? ""
            articleRealm.articleDescription  = article.articleDescription ?? ""
            articleRealm.url = article.url ?? ""
            articleRealm.urlToImage = article.urlToImage ?? ""
            if let unwrappedPublishedAt = article.publishedAt {
                articleRealm.publishedAt = unwrappedPublishedAt
                articleRealm.publishedAt.removeLast(10)
            } else { articleRealm.publishedAt = ""}
            articleRealm.content = article.content ?? ""
            articleRealm.sourceName  = article.source.name ?? ""
            articlesRealm.append(articleRealm)
        }
        return articlesRealm
    }
    
    func anotherArticleConverter(articles: [Article]) -> [EverythingCached] {
        var articlesRealm: [EverythingCached] = []
        for article in articles {
            let articleRealm = EverythingCached()
            articleRealm.author = article.author ?? ""
            articleRealm.title = article.title ?? ""
            articleRealm.articleDescription  = article.articleDescription ?? ""
            articleRealm.url = article.url ?? ""
            articleRealm.urlToImage = article.urlToImage ?? ""
            if let unwrappedPublishedAt = article.publishedAt {
                articleRealm.publishedAt = unwrappedPublishedAt
                articleRealm.publishedAt.removeLast(10)
            } else { articleRealm.publishedAt = ""}
            articleRealm.content = article.content ?? ""
            articleRealm.sourceName  = article.source.name ?? ""
            articlesRealm.append(articleRealm)
        }
        return articlesRealm
    }
}
