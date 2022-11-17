//
//  scheduleApp.swift
//  schedule
//
//  Created by 足立　岳大 on 2022/06/29.
//

import SwiftUI
import Firebase

@main
struct scheduleApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // Intailzing Firebase...
    init(){
        FirebaseApp.configure()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        //appearance.backgroundColor = UIColor(#colorLiteral(red: 0.337254902, green: 0.7294117647, blue: 0.3941176471, alpha: 1))
        appearance.backgroundColor = UIColor(Color.gray.opacity(0.6))
        appearance.shadowColor = UIColor(Color.green.opacity(0.6)) //navigationbarの下線部を消すのに必要
        UINavigationBar.appearance().shadowImage = UIImage() //navigationbarの下線部を消すのに必要
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        //UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
//        UINavigationBar.appearance().isTranslucent = false
        let appearanceTab = UITabBarAppearance()
        //appearance.backgroundColor =  UIColor.gray
        UITabBar.appearance().standardAppearance = appearanceTab
        UITabBar.appearance().scrollEdgeAppearance = appearanceTab
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(usersID())
        }
    }
}
