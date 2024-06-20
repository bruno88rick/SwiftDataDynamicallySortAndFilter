//
//  Job.swift
//  SwiftDataDynamicallySortAndFilter
//
//  Created by Bruno Oliveira on 20/06/24.
//

import SwiftData
import Foundation

//CREATING A RELATIONSHIP TO USERS AND JOBS TO DO

/*SwiftData allows us to create models that reference each other, for example saying that a School model has an array of many Student objects, or an Employee model stores a Manager object.These are called relationships, and they come in all sorts of forms. SwiftData does a good job of forming these relationships automatically as long as you tell it what you want, although there's still some room for surprises!*/

//SwiftData with iCloud has a requirement that local SwiftData does not: all properties must be optional or have default values, and all relationship must be optional. The first of those is a small annoyance, but the second is a much bigger annoyance – it can be quite disruptive for your code. However, they are requirements and not merely suggestions:

@Model
class Job {
    //var name: String
    var name: String = "None" //for SwiftData with iCloud
    var priority: Int = 1
    //Notice how I've made the owner property refer directly to the User model – I've told SwiftData explicitly that the two models are linked together.
    var owner: User?
    
    init(name: String, priority: Int, owner: User? = nil) {
        self.name = name
        self.priority = priority
        self.owner = owner
    }
}
