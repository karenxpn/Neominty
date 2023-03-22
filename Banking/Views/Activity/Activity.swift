//
//  Activity.swift
//  Banking
//
//  Created by Karen Mirakyan on 22.03.23.
//

import SwiftUI

struct Activity: View {
    @StateObject private var activityVM = ActivityViewModel()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct Activity_Previews: PreviewProvider {
    static var previews: some View {
        Activity()
    }
}
