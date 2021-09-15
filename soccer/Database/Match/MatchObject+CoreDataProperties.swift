//
//  MatchObject+CoreDataProperties.swift
//  soccer
//
//  Created by Mikhail Andreev on 15.09.2021.
//
//

import Foundation
import CoreData

extension MatchObject {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<MatchObject> {
    return NSFetchRequest<MatchObject>(entityName: "MatchObject")
  }

  @NSManaged public var id: Int64
  @NSManaged public var date: Date
  @NSManaged public var home: TeamObject
  @NSManaged public var away: TeamObject
  @NSManaged public var league: LeagueObject?

}

extension MatchObject: Identifiable {

}
