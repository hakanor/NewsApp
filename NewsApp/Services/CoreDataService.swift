//
//  CoreDataService.swift
//  NewsApp
//
//  Created by Hakan Or on 26.07.2022.
//

import Foundation
import UIKit



class CoreDataService{
    public var items : [ArticleEntity]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init() {
        fetchArticlesFromCoreData()
    }
    
    public func fetchArticlesFromCoreData(){
        do{
            self.items = try self.context.fetch(ArticleEntity.fetchRequest())
        } catch {
            
        }
    }
    
    public func checkObjectExistInCoreData(title:String) -> Bool{
        fetchArticlesFromCoreData()
        for item in items ?? [] {
            if(item.title == title){
                return true
            }
        }
        return false
    }
    public func saveToCoreData(with viewModel: HomeTableViewCellViewModel){
        
        if (checkObjectExistInCoreData(title:viewModel.title) == false){
            let newArticle = ArticleEntity(context: self.context)
            newArticle.url = viewModel.url ?? ""
            newArticle.content = viewModel.content
            newArticle.publishedAt = viewModel.publishedAt
            newArticle.urlToImage = viewModel.urlToImage
            newArticle.source = viewModel.sourceName
            newArticle.title = viewModel.title
            newArticle.subtitle = viewModel.description

            do{
                try self.context.save()
            } catch {
                
            }
        }
        
    }
    
    public func deleteFromCoreData(with viewModel : HomeTableViewCellViewModel){
        
        let articleToBeDeleted = ArticleEntity(context: self.context)
        articleToBeDeleted.url = viewModel.url ?? ""
        articleToBeDeleted.content = viewModel.content
        articleToBeDeleted.publishedAt = viewModel.publishedAt
        articleToBeDeleted.urlToImage = viewModel.urlToImage
        articleToBeDeleted.source = viewModel.sourceName
        articleToBeDeleted.title = viewModel.title
        articleToBeDeleted.subtitle = viewModel.description
        
        print(articleToBeDeleted)
        self.context.delete(articleToBeDeleted)
        do{
            try self.context.save()
        } catch {
            
        }
    }
    
    public func deleteFromCoreData(with articleEntity : ArticleEntity){
        self.context.delete(articleEntity)
        do{
            try self.context.save()
        } catch {
            
        }
    }
}
