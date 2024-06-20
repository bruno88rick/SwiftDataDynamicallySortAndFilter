//
//  User.swift
//  SwiftDataDynamicallySortAndFilter
//
//  Created by Bruno Oliveira on 20/06/24.
//

import Foundation
import SwiftData


//SwiftData with iCloud has a requirement that local SwiftData does not: all properties must be optional or have default values, and all relationship must be optional. The first of those is a small annoyance, but the second is a much bigger annoyance – it can be quite disruptive for your code. However, they are requirements and not merely suggestions:

@Model
class User {
    //var name: String
    var name: String = "Anonymous" //for Seift Data With icloud
    var city: String = "Unknown"
    var joinDate: Date = Date.now
    //jobs have an owner, and users have an array of jobs – the relationship goes both ways, which is usually a good idea because it makes your data easier to work with.
    /*There is one small catch, though, and it's worth covering before we move on: we've linked User and Job so that one user can have lots of jobs to do, but what happens if we delete a user? The answer is that all their jobs remain intact – they don't get deleted. This is a smart move from SwiftData, because you don't get any surprise data loss. If you specifically want all a user's job objects to be deleted at the same time, we need to tell SwiftData that. This is done using an @Relationship macro, providing it with a delete rule that describes how Job objects should be handled when their owning User is deleted. The default delete rule is called .nullify, which means the owner property of each Job object gets set to nil, marking that they have no owner. We're going to change that to be .cascade, which means deleting a User should automatically delete all their Job objects. It's called cascade because the delete keeps going for all related objects – if our Job object had a locations relationship, for example, then those would also be deleted, and so on.*/
    //var jobs = [Job]()
    
    ///@Relationship(deleteRule: .cascade) var jobs = [Job]()
    @Relationship(deleteRule: .cascade) var jobs: [Job]? = [Job]() //for swift Data with icloud
    //this macro tell swiftData to delete all users Jobs if the user is deleted.
    
    //I/'m not a particularly big fan of scattering that kind of code everywhere around a project, so if I'm using jobs regularly I'd much rather create a read-only computed property called unwrappedJobs or similar – something that either returns jobs if it has a value, or an empty array otherwise, like this:
    var unwrappedJobs: [Job] {
        jobs ?? []
    }
    
    init(name: String, city: String, joinDate: Date) {
        self.name = name
        self.city = city
        self.joinDate = joinDate
    }
}

/*That array will start working immediately, even if our data base still have users created before the implementarion of the Job model and SwiftData will load all the jobs for a user when they are first requested, so if they are never used at all it will just skip that work.
 
 Even better, the next time our app launches SwiftData will silently add the jobs property to all its existing users, giving them an empty array by default. This is called a migration: when we add or delete properties in our models, as our needs evolve over time. SwiftData can do simple migrations like this one automatically, but as you progress further you'll learn how you can create custom migrations to handle bigger model changes.*/
