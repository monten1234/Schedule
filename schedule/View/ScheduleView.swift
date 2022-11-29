//
//  HomeView.swift
//  schedule
//
//  Created by 足立　岳大 on 2022/07/01.
//

import SwiftUI
import FirebaseAuth

struct ScheduleView: View {
    @StateObject var viewModel = ScheduleViewModel()
    @State var infos = [SInfo]()
    @State var yotei:String = ""
    @State var isShowingDialog: Bool = false
    @State var Item:SInfo = SInfo(date: Date(), title: "", memo: "")
    @State var Scheduleid: String?
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.green.opacity(0.1)
//                    .edgesIgnoringSafeArea(.all)
                    .ignoresSafeArea()
                VStack{
                    ScrollView(.vertical, showsIndicators: false) {
    //                    VStack {
                            ForEach(infos) { item in
                                Button {
                                    Item = item
                                    Scheduleid = item.id
                                    isShowingDialog = true
                                    print(Scheduleid ?? "err")
                                    
                                } label: {
                                    //スケジュール
                                    VStack {
                                        let current = Calendar.current
                                        let day = current.component(.day, from: item.date)
                                        let month = current.component(.month, from: item.date)
                                        Group {
                                            VStack (alignment: .leading){
                                                Text("\(month)月\(day)日")
                                                    .font(.title)
                                                    .frame(alignment: .leading)
                                            }
                                            Text("\(item.title ?? "")")
                                                .font(.title)
                                                .frame(width: 160, height: 40)
                                                .fixedSize()
                                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                            Text("\(item.memo ?? "nill")")
                                                .font(.title3)
                                                .fixedSize()
                                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                                .padding(.bottom)
                                        }
                                        .foregroundColor(.black)
                                    }
                                    .frame(width: 300)
                                    .background(Color.green.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.top)
                                }
                                NavigationLink(destination: EditView(ITEM: $Item, scheduleid: $Scheduleid), isActive: $isShowingDialog) {
                                    EmptyView()
                                }
                            }
                    }
                    Spacer()
                }
            }
            .onAppear{
                Task{
                    infos = await viewModel.getInfo()
                    //日付順にソート　https://ymgsapo.com/2020/06/13/how-to-sort-object-by-date/
                    infos = infos.sorted(by: {
                        $0.date.compare($1.date) == .orderedAscending
                    })
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink (destination: SettingView()) {
                        Image(systemName: ("gearshape.fill"))
                            .foregroundColor(.black.opacity(0.7))
                    }
                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink(destination: FriendAddView()) {
//                        Image(systemName: "person.crop.circle.badge.plus")
//                    }
//                }
            }
            .navigationTitle("スケジュール")
            .navigationBarTitleDisplayMode(.inline)
//            .navigationViewStyle(.stack)
        }
    }
}
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//            .environmentObject(Time())
//    }
//}
