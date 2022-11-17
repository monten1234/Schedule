//
//  LoginView.swift
//  schedule
//
//  Created by 足立　岳大 on 2022/07/18.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

struct LoginView: View {
    
    @State var mail:String = ""
    @State var password:String = ""
    //@State public var errorMessage:String = ""
//    @State private var shouldShowSecondView: Bool = false
    @State var isShowSinUpView: Bool = false
    @Binding var isPresentedLoginView: Bool

    
    var body: some View {
        
//        NavigationView {
            VStack(spacing: 30){
                // メールアドレス
                TextField("メールアドレスを入力してください",text: $mail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // パスワード
                SecureField("パスワードを入力してください",text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                //認証
                Button {
                    login()
                } label: {
                    Text("ログインする")
                }
                
//                NavigationLink(destination: HomeView(), isActive: $shouldShowSecondView, label: {
//                    Button (action:{
//                        login()
//                    }) {
//                        Text("ログインする")
//                    }
//                    .navigationBarBackButtonHidden(true)
//                })
                
//                NavigationLink(destination: HomeView(), isActive: $shouldShowSecondView) {
//                    Button (action:{
//                        login()
//                    }) {
//                        Text("ログインする")
//                    }
//                }

                Button {
                    isShowSinUpView = true
                } label: {
                    Text("アカウントをお持ちでない方")
                }
                .fullScreenCover(isPresented: $isShowSinUpView) {
                    SignUpView(isPresentedSignUpView: $isShowSinUpView)
                }
            }
//        }

    }


    func login() {
        Auth.auth().signIn(withEmail: mail, password: password) { authResult, error in
            if error == nil {
                self.isPresentedLoginView = false
//                NavigationLink(destination: HomeView(),isActive: $shouldShowSecondView) {
//                    EmptyView()
//                }
            } else {
                print(error!)
            }
        }
    }
}


struct SignUpView: View {
    @State var name:String = ""
    @State var mail:String = ""
    @State var password:String = ""
    @Binding  var isPresentedSignUpView: Bool
    //@State public var errorMessage:String = ""
    
    var body: some View {
        VStack(spacing: 30){
            
            // userid
            TextField("ユーザIDを入力してください",text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // メールアドレス
            TextField("メールアドレスを入力してください",text: $mail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // パスワード
            SecureField("パスワードを入力してください",text:$password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            
            // 認証
            Button {
                signup()
            } label: {
                Text("サインアップ")
            }
        }
    }
    
    func signup() {
        Auth.auth().createUser(withEmail: mail, password: password) { authResult, error in
            if error == nil {
                isPresentedSignUpView = false
                do {
                    let user = UserSample(name: name, mail: mail)
                    try Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "err").setData(from: user)
                } catch {
                    //print(error)
                }
            } else {
                //失敗の処理
                print(error!)
            }
        }
    }
}


//struct UserInfo: Codable, Identifiable {
//    @DocumentID var id: String?
//    var mail: String?
//    var password: String?
//    enum Codingkeys: String, CodingKey {
//        case mail
//        case password
//    }
//}

