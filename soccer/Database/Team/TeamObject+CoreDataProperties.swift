//
//  TeamObject+CoreDataProperties.swift
//  soccer
//
//  Created by Mikhail Andreev on 15.09.2021.
//
//

import Foundation
import CoreData

extension TeamObject {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<TeamObject> {
    return NSFetchRequest<TeamObject>(entityName: "TeamObject")
  }

  @NSManaged public var id: Int64
  @NSManaged public var name: String
  @NSManaged public var goals: Int64
  @NSManaged public var logoPath: String
  @NSManaged public var home: MatchObject?
  @NSManaged public var away: MatchObject?

}

extension TeamObject: Identifiable {

}
