//
//  AdditionView.swift
//  schedule
//
//  Created by 足立　岳大 on 2022/07/02.
//

import SwiftUI


struct AdditionView: View {
    @StateObject var viewModel = ScheduleViewModel()
    @State private var date = Date()
    @State private var title = ""
    @State private var memo = ""
    @State private var isAlert = false
    @State var isRelease: Bool = true
    @State var page: Int?
    var body: some View {
        NavigationView {
            ZStack {
                Color.green.opacity(0.1)
                    .ignoresSafeArea()
                VStack {
                    TextField("タップしてタイトルを入力", text: $title)
                        .fixedSize()
                        .multilineTextAlignment(TextAlignment.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                               RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                               .stroke(Color.orange, lineWidth: 1.0)
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
                    Toggle(isOn: $isRelease) {
                        Text("公開する")
                    }
                    .fixedSize()
                    .padding()
                    Button {
                        if self.title == "" {
                            self.isAlert.toggle()
                        }
                        else{
                            if isRelease {
                                page = 1
                            } else {
                                viewModel.save(title: title, date: date, memo: memo)
                                self.title = ""
                                self.memo = ""
                            }
                        }
                    } label: {
                        ZStack {
                            Color.blue.opacity(0.8)
                                .frame(width: 80, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            Text("保存")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    NavigationLink(destination: ReleaseSelectionView(title: title, date: date, memo: memo), tag: 1, selection: $page) {
                        EmptyView()
                    }
                }
                .alert(isPresented: self.$isAlert){
                    Alert(title: Text("タイトルを入力してください"), dismissButton: .default(Text("OK")))
                }
            .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

