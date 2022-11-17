//
//  EditView.swift
//  schedule
//
//  Created by 足立　岳大 on 2022/08/18.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct EditView: View {
    @StateObject var viewModel = ScheduleViewModel()
    @Binding var ITEM:SInfo
    @State private var date = Date()
    @State private var title = ""
    @State private var memo = ""
    @State private var isAlert = false
    @Binding var scheduleid: String?
   
    
    var body: some View {

            ZStack {
                Color.green.opacity(0.1)
                    .ignoresSafeArea()
                
                    VStack {
                        TextField("タップしてタイトルを入力", text: $title)
                            .fixedSize()
                            .multilineTextAlignment(TextAlignment.center)
                            .overlay(
                                   RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                                   .stroke(Color.orange, lineWidth: 1.0)
                                       .padding(-8.0)
                            )
                            .padding()
                        DatePicker(selection: $date, displayedComponents: .date, label: {
                            Text("日付")
                                .font(.body)
                        })
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                        .padding(.trailing, 8)
                        .fixedSize()
                        HStack {
                            Text("メモ")
                                .padding(.leading, 40)
                            Spacer()
                        }
                        TextEditor(text: $memo)
                            .frame(width: 300, height: 200)
                            .border(Color.black)
                        
                        Button {
                            if self.title == "" {
                                self.isAlert.toggle()
                            }
                            else{
                                editsave(title: title, date: date, memo: memo)
                                self.title = ""
                                self.memo = ""
                            }
                        } label: {
                            ZStack {
                                Color.blue.opacity(0.8)
                                    .frame(width: 75, height: 40)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                Text("保存")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .alert(isPresented: self.$isAlert){
                        Alert(title: Text("タイトルを入力してください"), dismissButton: .default(Text("OK")))
                    }
                    .navigationBarTitleDisplayMode(.inline)
                
            }
            .onAppear{
                date = ITEM.date
                title = ITEM.title ?? ""
                memo = ITEM.memo ?? ""
            }
            
        
    }
    func editsave(title: String, date: Date, memo: String) {
        do {
            let user = SInfo(date: date, title: title, memo: memo)
            try Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "err").collection("schedule").document(scheduleid ?? "").setData(from: user)
        } catch {
            print(error)
        }
    }
}
