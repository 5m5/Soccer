//
//  MOTeam+CoreDataProperties.swift
//  soccer
//
//  Created by Mikhail Andreev on 18.09.2021.
//
//

import Foundation
import CoreData

extension MOTeam {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<MOTeam> {
    return NSFetchRequest<MOTeam>(entityName: "MOTeam")
  }

  @NSManaged public var id: Int64
  @NSManaged public var name: String?
  @NSManaged public var country: String?
  @NSManaged public var logoPath: String?
  @NSManaged public var players: NSSet?
  @NSManaged public var stadium: MOStadium?

}

// MARK: Generated accessors for players
extension MOTeam {

  @objc(addPlayersObject:)
  @NSManaged public func addToPlayers(_ value: MOPlayer)

  @objc(removePlayersObject:)
  @NSManaged public func removeFromPlayers(_ value: MOPlayer)

  @objc(addPlayers:)
  @NSManaged public func addToPlayers(_ values: NSSet)

  @objc(removePlayers:)
  @NSManaged public func removeFromPlayers(_ values: NSSet)

}

extension MOTeam: Identifiable {

}
