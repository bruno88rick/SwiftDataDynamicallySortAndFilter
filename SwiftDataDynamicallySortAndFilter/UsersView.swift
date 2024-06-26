//
//  UsersView.swift
//  SwiftDataDynamicallySortAndFilter
//
//  Created by Bruno Oliveira on 20/06/24.
//

import SwiftData
import SwiftUI

struct UsersView: View {
    @Environment(\.modelContext) var modelContext
    
    /*we need a way to customize the query that gets run. As things stand, just using @Query var users: [User] means SwiftData will load all the users with no filter or sort order, but really we want to customize one or both of those from ContentView – we want to pass in some data. This is best done by passing a value into the view using an initializer, like above on init():*/
    @Query var users: [User]
    //We don't need to change the @Query we use to load the Job relationship, just go ahead and use the array on the User class like normal. For example, we could show a list of users and their job count:
    
    @State private var path = [User]()
    
    var body: some View {
        List(users) { user in
            NavigationLink(value: user) {
                HStack {
                    Text(user.name)
                    
                    Spacer()
                    
                    ///Text(String(user.jobs?.count ?? 0))
                    // A Better idea to do instead of thease is: 'm not a particularly big fan of scattering that kind of code everywhere around a project, so if I'm using jobs regularly I'd much rather create a read-only computed property called unwrappedJobs or similar – something that either returns jobs if it has a value, or an empty array otherwise. See computate property on Job Class:
                    Text(String(user.unwrappedJobs.count))
                        .fontWeight(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(.capsule)
                }
            }
        }
        .navigationDestination(for: User.self) { user in
            EditUserView(user: user)
        }
        .onAppear() {
            addSample()
        }
    }
    //passing dinamically only filters
    /*init(minimumJoinDate: Date) {
        _users = Query(filter: #Predicate<User> { user in
            user.joinDate >= minimumJoinDate
        }, sort: \User.name)
    }*/
    
    //passing dinamically filter and sort order with sortDescriptor using Generics systemm <User>
    init(minimumJoinDate: Date, sortOrder: [SortDescriptor<User>]) {
        _users = Query(filter: #Predicate<User> { user in
            user.joinDate >= minimumJoinDate
        }, sort: sortOrder)
    }
    
    func addSample() {
        let user1 = User(name: "Piper Chapman", city: "New York", joinDate: .now)
        let job1 = Job(name: "Organize sock Drawer", priority: 3)
        let job2 = Job(name: "Make plans with Alex", priority: 4)
        
        modelContext.insert(user1)
        
        user1.jobs?.append(job1)
        user1.jobs?.append(job2)
        
    }
    
    
    /*notice that there's an underscore before users. That's intentional: we aren't trying to change the User array, we're trying to change the SwiftData query that produces the array. The underscore is Swift's way of getting access to that query, which means we're creating the query from whatever date gets passed in.*/
    /*This same approach works equally well with sorting data: we can control an array of sort descriptors in ContentView, then pass them into the initializer of UsersView to have them adjust the query.This uses Swift's generics again: the SortDescriptor type needs to know what it's sorting, so we need to specify User inside angle brackets. You can see on the initializer passing the Predicate Dinamically and the sort dinamucally too:*/
}

#Preview {
    UsersView(minimumJoinDate: .now, sortOrder: [SortDescriptor(\User.name), SortDescriptor(\User.joinDate)])
        .modelContainer(for: User.self)
}
