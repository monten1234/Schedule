//
//  HomeView.swift
//  schedule
//
//  Created by 足立　岳大 on 2022/07/18.
//

import SwiftUI

struct HomeView: View {
    @State var selectedTag = 1
    @State var isShowLoginView: Bool = true
    
    private var frameWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var body: some View {
        TabView (selection: $selectedTag){
            ScheduleView()
                .tabItem {
                    Image(systemName: "scroll")
                }.tag(1)
            Home()
                .tabItem {
                    Image(systemName: "calendar")
                }.tag(2)
            AdditionView()
//                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                }.tag(3)
            FriendView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                }.tag(4)
        }
        //　ログイン画面を出す
//        .fullScreenCover(isPresented: $isShowLoginView) {
//            LoginView(isPresentedLoginView: $isShowLoginView)
//        }
//        .onAppear(){
//            firstVisitSetup()
//        }
//        .fullScreenCover(isPresented: $isShowLoginView, content: {
//            // Tutorial Viewに飛ばす
//            LoginView(isPresentedLoginView: $isShowLoginView)
//
//        })
    }
//    func firstVisitSetup() {
//        let visit = UserDefaults.standard.bool(forKey: CurrentUserDefaults.isFirstVisit)
//        if visit {
//            print("Two times")
//
//            //MARK: 以下はプレビュー用
//            UserDefaults.standard.set(false, forKey: CurrentUserDefaults.isFirstVisit)
//        }else{
//            print("First Access")
//            isShowLoginView.toggle()
//            UserDefaults.standard.set(true, forKey: CurrentUserDefaults.isFirstVisit)
//        }
//
//    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
