//
//  CustomDatePicker.swift
//  ElegantTaskApp (iOS)
//
//  Created by Balaji on 28/09/21.
//

import SwiftUI

struct CustomDatePicker: View {
    @StateObject var viewModel = ScheduleViewModel()
    @Binding var currentDate: Date
    @State var infos = [SInfo]()
//    @State var tasks = [SInfo]()
//    @State var tasks: SInfo?


    // Month update on arrow button clicks...
    @State var currentMonth: Int = 0

    var body: some View {

        VStack(spacing: 35){

            // Days...
            let days: [String] = ["日","月","火","水","木","金","土"]

            HStack(spacing: 20){

                VStack(alignment: .leading, spacing: 10) {

                    Text(extraDate()[0])
                        .font(.caption)
                        .fontWeight(.semibold)

                    Text(extraDate()[1])
                        .font(.title.bold())
                }

                Spacer(minLength: 0)

                Button {
                    withAnimation{
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }

                Button {

                    withAnimation{
                        currentMonth += 1
                    }

                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            // Day View...

            HStack(spacing: 0){
                ForEach(days,id: \.self){day in

                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }

            // Dates....
            // Lazy Grid..
            let columns = Array(repeating: GridItem(.flexible()), count: 7)

            LazyVGrid(columns: columns,spacing: 15) {

                ForEach(extractDate()){value in

                    CardView(value: value)
                        .background(

                            Capsule()
                                .fill(.pink)
                                .padding(.horizontal,8)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                        )
                        .onTapGesture {
                            currentDate = value.date
                        }
                }
            }

            VStack(spacing: 15){
                
                Text("スケジュール")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.vertical,20)

                if let info = infos.filter({ info in
                    return isSameDay(date1: info.date, date2: currentDate)
                }){
                    ForEach (info) { info in
                        VStack(alignment: .leading, spacing: 10) {
//                            Text(info.date.addingTimeInterval(CGFloat.random(in: 0...5000)),style: .time)

                            Text(info.title ?? "err")
                                .font(.title2.bold())
                        }
                        .padding(.vertical,10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(

                            Color(.red)
                                .opacity(0.5)
                                .cornerRadius(10)
                        )
                    }
//                    print(task.title)
                }
                
                
//                else{
//
//                    Text("No Task Found")
//                }
            }
            .padding()
        }
        .onChange(of: currentMonth) { newValue in

            // updating Month...
            currentDate = getCurrentMonth()
        }
        .onAppear{
            Task{
                infos = await viewModel.getInfo()
//                if let task = infos.first(where: { task in
//                    return isSameDay(date1: task.date, date2: currentDate)
//                }){
//                    tasks.append(task)
//                }
//                let task = infos.first(where: { task in
//                    return isSameDay(date1: task.date, date2: currentDate)
//                })
            }
        }
    }

    @ViewBuilder
    func CardView(value: DateValue)->some View{

        VStack{

            if value.day != -1{

                if let task = infos.first(where: { task in

                    return isSameDay(date1: task.date, date2: value.date)
                }){
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: task.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)

                    Spacer()

                    Circle()
                        .fill(isSameDay(date1: task.date, date2: currentDate) ? .white : .pink)
                        .frame(width: 8,height: 8)
                }
                else{

                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)

                    Spacer()
                }
            }
        }
        .padding(.vertical,9)
        .frame(height: 60,alignment: .top)
    }

    // checking dates...
    func isSameDay(date1: Date,date2: Date)->Bool{
        let calendar = Calendar.current

        return calendar.isDate(date1, inSameDayAs: date2)
    }

    // extrating Year And Month for display...
    func extraDate()->[String]{

        let calendar = Calendar.current
        let month = calendar.component(.month, from: currentDate) - 1
        let year = calendar.component(.year, from: currentDate)

        return ["\(year)",calendar.monthSymbols[month]]
    }

    func getCurrentMonth()->Date{

        let calendar = Calendar.current

        // Getting Current Month Date....
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else{
            return Date()
        }

        return currentMonth
    }

    func extractDate()->[DateValue]{

        let calendar = Calendar.current

        // Getting Current Month Date....
        let currentMonth = getCurrentMonth()

        var days = currentMonth.getAllDates().compactMap { date -> DateValue in

            // getting day...
            let day = calendar.component(.day, from: date)

            return DateValue(day: day, date: date)
        }

        // adding offset days to get exact week day...
        let firstWeekday = calendar.component(.weekday, from: days.first!.date)

        for _ in 0..<firstWeekday - 1{
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }

        return days
    }
}

// Extending Date to get Current Month Dates...
extension Date{

    func getAllDates()->[Date]{

        let calendar = Calendar.current

        // getting start Date...
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year,.month], from: self))!

        let range = calendar.range(of: .day, in: .month, for: startDate)!

        // getting date...
        return range.compactMap { day -> Date in

            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}
