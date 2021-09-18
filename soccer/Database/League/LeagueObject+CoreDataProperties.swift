//
//  LeagueObject+CoreDataProperties.swift
//  soccer
//
//  Created by Mikhail Andreev on 15.09.2021.
//
//

import Foundation
import CoreData

extension LeagueObject {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<LeagueObject> {
    return NSFetchRequest<LeagueObject>(entityName: "LeagueObject")
  }

  @NSManaged public var id: Int64
  @NSManaged public var name: String
  @NSManaged public var logoPath: String?
  @NSManaged public var matches: NSSet

}

// MARK: Generated accessors for matches
extension LeagueObject {

  @objc(addMatchesObject:)
  @NSManaged public func addToMatches(_ value: MatchObject)

  @objc(removeMatchesObject:)
  @NSManaged public func removeFromMatches(_ value: MatchObject)

  @objc(addMatches:)
  @NSManaged public func addToMatches(_ values: NSSet)

  @objc(removeMatches:)
  @NSManaged public func removeFromMatches(_ values: NSSet)

}

extension LeagueObject: Identifiable {

}
