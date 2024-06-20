//
//  SwiftDataDynamicallySortAndFilterApp.swift
//  SwiftDataDynamicallySortAndFilter
//
//  Created by Bruno Oliveira on 20/06/24.
//

import SwiftUI

@main
struct SwiftDataDynamicallySortAndFilterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}

/*When we used the modelContainer() modifier in our App struct, we passed in User.self so that SwiftData knew to set up storage for that model. We don't need to add Job.self there because SwiftData can see there's a relationship between the two, so it takes care of both automatically.*/

