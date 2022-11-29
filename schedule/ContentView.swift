//
//  ContentView.swift
//  schedule
//
//  Created by 足立　岳大 on 2022/06/29.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var log_status = false
//    @StateObject var viewModel = Time()
//    @State var timeArray = []
//    @State var selectedTag = 1
//
//    private var frameWidth: CGFloat {
//        UIScreen.main.bounds.width
//    }
//
//    var body: some View {
//        TabView (selection: $selectedTag){
//            CalendarView()
//                .environmentObject(viewModel)
//                .tabItem {
//                    Image(systemName: "calendar")
//
//                }.tag(1)
//            AdditionView()
//                .environmentObject(viewModel)
//                .tabItem {
//                    Image(systemName: "plus.circle.fill")
//                }.tag(2)
//        }
//    }
    var body: some View {
        if log_status {
            HomeView()
        } else {
            LoginView()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .environmentObject(Time())
//    }
//}
