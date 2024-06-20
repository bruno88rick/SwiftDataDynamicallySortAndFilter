//
//  ContentView.swift
//  SwiftDataDynamicallySortAndFilter
//
//  Created by Bruno Oliveira on 20/06/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var showingUpcomingOnly = false
    
    //default value for sortOrder passing in the UsersView, but will be modified by user
    @State private var sortOrder = [
        SortDescriptor(\User.name),
        SortDescriptor(\User.joinDate),
    ]
    
    var body: some View {
        NavigationStack() {
            //That passes one of two dates into UsersView: when our Boolean property is true we pass in .now so that we only show users who will join after the current time, otherwise we pass in .distantPast, which is at least 2000 years in the past – unless our users include some Roman emperors, they will all have join dates well after this and so all users will be shown.
            UsersView(minimumJoinDate: showingUpcomingOnly ? .now : .distantPast, sortOrder: sortOrder)
                .navigationTitle("Users")
                .toolbar {
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(showingUpcomingOnly ? "Show Everyone" : "Show Upcoming") {
                            showingUpcomingOnly.toggle()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing){
                        Button("Add User", systemImage: "plus") {
                            let user = User(name: "", city: "", joinDate: .now)
                            modelContext.insert(user)
                        }
                    }
                    
                    /*And finally we need a way to adjust that array dynamically. One option is to use a Picker showing two options: Sort by Name, and Sort by Join Date. That in itself isn't tricky, but how do we attach a SortDescriptor array to each option? The answer lies in a useful modifier called tag(), which lets us attach specific values of our choosing to each picker option. Here that means we can literally make the tag of each option its own SortDescriptor array, and SwiftUI will assign that tag to the sortOrder property automatically.*/
                    ToolbarItem(placement: .topBarTrailing){
                        
                        /*When you run the app now, chances are you won't see what you expected. Depending on which device you're using, rather than showing "Sort" as a menu with options inside, you'll either see:
                         
                        - Three dots in a circle, and pressing that reveals the options.
                        - "Sort by Name" shown directly in the navigation bar, and tapping that lets you change to Join Date.
                        
                         Both options aren't great, but I want to use this chance to introduce another useful SwiftUI view called Menu. This lets you create menus in the navigation bar, and you can place buttons, pickers, and more inside there. In this case, if we wrap our current Picker code with a Menu, we'll get a much better result*/
                        
                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                            
                            Picker("Sort", selection: $sortOrder) {
                                Text("Sort by Name")
                                    .tag([
                                        SortDescriptor(\User.name),
                                        SortDescriptor(\User.joinDate),
                                    ])
                                
                                Text("Sort by Joing date")
                                    .tag([
                                        SortDescriptor(\User.joinDate),
                                        SortDescriptor(\User.name)
                                    ])
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Add Sample", systemImage: "book.pages") {
                            
                            try? modelContext.delete(model: User.self)
                            
                            let first = User(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
                            let second = User(name: "Rosa Diaz", city: "New Yourk", joinDate: .now.addingTimeInterval(86400 * -5))
                            let third = User(name: "Roy Kent", city: "London", joinDate: .now.addingTimeInterval(86400 * 5))
                            let fourth = User(name: "Johnny English", city: "London", joinDate: .now.addingTimeInterval(86400 * 10))
                            
                            modelContext.insert(first)
                            modelContext.insert(second)
                            modelContext.insert(third)
                            modelContext.insert(fourth)
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}

