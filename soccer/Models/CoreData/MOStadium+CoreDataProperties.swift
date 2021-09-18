//
//  MOStadium+CoreDataProperties.swift
//  soccer
//
//  Created by Mikhail Andreev on 18.09.2021.
//
//

import Foundation
import CoreData

extension MOStadium {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<MOStadium> {
    return NSFetchRequest<MOStadium>(entityName: "MOStadium")
  }

  @NSManaged public var id: Int64
  @NSManaged public var name: String?
  @NSManaged public var address: String?
  @NSManaged public var city: String?
  @NSManaged public var team: MOTeam?

}

extension MOStadium: Identifiable {

}
