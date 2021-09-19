//
//  MOPlayer+CoreDataProperties.swift
//  soccer
//
//  Created by Mikhail Andreev on 18.09.2021.
//
//

import Foundation
import CoreData

extension MOPlayer {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<MOPlayer> {
    return NSFetchRequest<MOPlayer>(entityName: "MOPlayer")
  }

  @NSManaged public var id: Int64
  @NSManaged public var name: String?
  @NSManaged public var age: Int64
  @NSManaged public var number: Int64
  @NSManaged public var position: String?
  @NSManaged public var photoPath: String?
  @NSManaged public var team: MOTeam?

}

extension MOPlayer: Identifiable {

}
