//
//  Article+CoreDataProperties.swift
//  Jet2Test_Abhishek
//
//  Created by Abhishek Yadav on 28/06/20.
//  Copyright © 2020 Abhishek Yadav. All rights reserved.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    //MARK: - Entity based Keys.
    @NSManaged public var comments: Int64
    @NSManaged public var content: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var id: String?
    @NSManaged public var likes: Int64
    @NSManaged public var name: String?
    @NSManaged public var lastname: String?
    @NSManaged public var designation: String?
    @NSManaged public var avatar: String?
    @NSManaged public var image: String?
    @NSManaged public var url: String?
    @NSManaged public var title: String?

}
