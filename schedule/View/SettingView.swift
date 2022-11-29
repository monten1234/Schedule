//
//  SettingView.swift
//  schedule
//
//  Created by 足立　岳大 on 2022/11/21.
//

import SwiftUI
import FirebaseAuth

struct SettingView: View {
    @AppStorage("log_status") var log_status = false
    
    var body: some View {
//        ScrollView(.vertical, showsIndicators: false){
            Button {
                logout()
            } label: {
                Text("ログアウトする")
                    .foregroundColor(.blue)
            }
//        }
    }
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            log_status = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

//struct SettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingView()
//    }
//}
