//
//  TimelineView.swift
//  InToTheSeoul
//
//  Created by 김동현 on 2023/06/05.
//

import SwiftUI

struct TimelineView: View {
    @State var workDatum = Array(CoreDataManager.coreDM.readWorkData().reversed())
    
    var body: some View {
        VStack {
            if workDatum.count != 0 {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(0 ..< workDatum.count) { index in
                            if index == 0 {
                                ScrollCell(isFirstCell: true, workData: workDatum[index])
                            } else {
                                ScrollCell(workData: workDatum[index])
                            }
                        }
                    }
                    
                }
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                
            } else {
                Text("데이터가 없습니다.")
                    .textFontAndColor(.h1)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}


struct ScrollCell: View {
    // TODO: 코어데이터 매니저로 데이터를 가져와야 함.

    @State var isFirstCell: Bool = false
    @State var workData: WorkData
    
    // Scroll에서는 필요없는 변수. MyRecordView를 재사용하기 위해 있는 변수이다.
    @State static var money = 1000
    @State static var accumulateDistance = 5.5
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: workData.date ?? Date())
    }
    var body: some View {
        HStack(spacing: 0) {
            Text("+\(workData.gainCoin)")
                .textFontAndColor(.h5)
                .frame(minWidth: 55)
            Spacer()
            ZStack {
                VStack {
                    if isFirstCell {
                        Spacer()
                    }
                    Image(isFirstCell ? "dashLineShort" : "dashLine")
                }
                Circle()
                    .frame(width: 16, height: 16)
                    .foregroundColor(isFirstCell ? Color.theme.green1 : Color.theme.green3)
            }
            
            Spacer()
            
            NavigationLink(destination: {
                MyRecordView(userMoney: ScrollCell.$money, accumulateDistance: ScrollCell.$accumulateDistance, workData: workData, buttonUse: false)
            }, label: {
                HStack(spacing: 0) {
                    VStack {
                        Text("\(formattedDate)")
                            .frame(width: 171, alignment: .leading)
                            .textFontAndColor(.body3)
                        Spacer()
                        HStack(spacing: 0) {
                            Text("\(workData.totalTime)분 동안 \(workData.totalDistance, specifier: "%.2f")km 산책")
                                .textFontAndColor(.h2)
                        }
                        .frame(width: 171, alignment: .leading)
                    }
                    .frame(maxHeight: 39)
                    
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 9, height: 15.5)
                        .foregroundColor(Color.theme.green1)
                }
                
            })
            .frame(width: 216, height: 76)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.theme.gray3, lineWidth: 2)
                
            )
            .cornerRadius(20)
        }
        .frame(maxWidth: .infinity, maxHeight: 102)
        
    }
}


struct TimelineView_Previewer: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
