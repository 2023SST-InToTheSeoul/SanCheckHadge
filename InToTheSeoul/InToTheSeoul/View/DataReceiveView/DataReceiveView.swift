//
//  DataReceiveView.swift
//  InToTheSeoul
//
//  Created by 김동현 on 2023/06/04.
//

import SwiftUI

struct DataReceiveView: View {
    
    // MARK: - 변수
    /**
     dataCheckList에 있는 모든 변수가 true가 될 때, NextButton이 활성화되게  함.
     각 변수마다 willSet을 달아서 값 변화를 감지하고 dataCheckList의 값을 변화하게 함.
     
     dataCheckList[0] : 이름 입력이 잘 되었는지 체크
     dataCheckList[1] : 성별을 탭했는지 체크
     dataCheckList[2] : 연령대를 탬했는지 체크
     
     genderActivatedList, ageCheckList의 경우, 하나가 체크될 경우, 나머지 버튼이 해제되어야 하기 때문에 Bool값을 Array에 담아놓았음.
     */
    // TODO: nameLimiter 최소 글자 수 설정 필요. 최소 글자 수 입력 시 dataCheckList의 0번 인덱스를 true로 만들어 주어야 함.
    @State var nameLimiter: TextLimiter = TextLimiter(limit: 8)
    
    
    /**
     여성(0), 남성(1)이 각각 클릭될 때, 상호 작용하도록 만드는 Bool Array
     */
    @State var genderActivatedList = [false, false] {
        willSet {
            dataCheckList[1] = true
        }
    }
    
    /**
     연령대를 체크하는 Array. true가 되어 있는 인덱스값을 나이대로 변환하여 저장한다.
     0 : 19세 이하 / 1 : 20대 / 2 : 30대 / 3 : 40대 / 4 : 50대 / 5 : 60대 이상
     */
    @State var ageCheckList = [false, false, false, false, false, false] {
        willSet {
            dataCheckList[2] = true
        }
    }
    
    @State var nextButtonActivated: Bool = false
    
    @State var dataCheckList = [false, false, false] {
        willSet {
            
            var checkNum = 0
            print(checkNum)
            for i in dataCheckList {
                print(i)
                checkNum += i == true ? 1 : 0
                if checkNum == 3 {
                    nextButtonActivated = true
                }
            }
            
        }
    }
    
    @Binding var isFirstLaunch: Bool
    @State private var focus: Bool = false

    // MARK: - body
    
    var body: some View {
        VStack(spacing: 0) {
            
            //Title
            VStack(spacing: 0) {
                Text("당신에 대해 알려주세요!")
                    .textFontAndColor(.h1)
                    .padding(1.5)
                Text("산책 코스를 추천하기 위해서, 기본 정보가 필요해요")
                    .textFontAndColor(.h2)
                    .padding(1.5)
            }
            
            Spacer()
            
            VStack(spacing: 0) {
                Text("이름을 알려주세요")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textFontAndColor(.h3)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                
                TextField("이름을 입력하세요", text: $nameLimiter.value , onEditingChanged: { editing in
                    focus = editing
                })
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .frame(height: 40)
                    .background(Color.theme.gray1)
                    .cornerRadius(20)
                    .onChange(of: nameLimiter.value, perform: { newValue in
                        if newValue.count >= 2 {
                            dataCheckList[0] = true
                        } else {
                            dataCheckList[0] = false
                        }
                    })
            }
            
            Spacer()
            
            VStack(spacing: 0) {
                Text("성별을 알려주세요")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textFontAndColor(.h3)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                
                HStack(spacing: 0) {
                    Button(action: {
                        
                    }, label: {
                        ButtonComponent(
                            buttonType: .genderButton,
                            content: "여성",
                            isActive: genderActivatedList[0],
                            action: {
                                genderActivatedList = [false, false]
                                genderActivatedList[0].toggle()
                                focus = false
                            }
                        )
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        ButtonComponent(
                            buttonType: .genderButton,
                            content: "남성",
                            isActive: genderActivatedList[1],
                            action: {
                                genderActivatedList = [false, false]
                                genderActivatedList[1].toggle()
                                focus = false
                            }
                        )
                    })
                }
            }
            
            Spacer()
            
            VStack(spacing: 0) {
                Text("연령대를 알려주세요")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textFontAndColor(.h3)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                HStack(spacing: 0) {
                    Button(action: {
                        
                    }, label: {
                        ButtonComponent(
                            buttonType: .miniButton,
                            content: "19세 이하",
                            isActive: ageCheckList[0],
                            action: {
                                for i in stride(from: 0, through: ageCheckList.count - 1, by: 1) {
                                    ageCheckList[i] = false
                                }
                                focus = false
                                ageCheckList[0].toggle()
                                
                            }
                        )
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        ButtonComponent(
                            buttonType: .miniButton,
                            content: "20~24세",
                            isActive: ageCheckList[1],
                            action: {
                                for i in stride(from: 0, through: ageCheckList.count - 1, by: 1) {
                                    ageCheckList[i] = false
                                }
                                focus = false
                                ageCheckList[1].toggle()
                            }
                        )
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        ButtonComponent(
                            buttonType: .miniButton,
                            content: "25~29세",
                            isActive: ageCheckList[2],
                            action: {
                                focus = false
                                for i in stride(from: 0, through: ageCheckList.count - 1, by: 1) {
                                    ageCheckList[i] = false
                                }
                                ageCheckList[2].toggle()
                            }
                        )
                    })
                    
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                HStack(spacing: 0) {
                    Button(action: {
                        
                    }, label: {
                        ButtonComponent(
                            buttonType: .miniButton,
                            content: "30~34세",
                            isActive: ageCheckList[3],
                            action: {
                                focus = false
                                for i in stride(from: 0, through: ageCheckList.count - 1, by: 1) {
                                    ageCheckList[i] = false
                                }
                                ageCheckList[3].toggle()
                            }
                        )
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        ButtonComponent(
                            buttonType: .miniButton,
                            content: "35~39세",
                            isActive: ageCheckList[4],
                            action: {
                                focus = false
                                for i in stride(from: 0, through: ageCheckList.count - 1, by: 1) {
                                    ageCheckList[i] = false
                                }
                                ageCheckList[4].toggle()
                            }
                        )
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        ButtonComponent(
                            buttonType: .miniButton,
                            content: "40세 이상",
                            isActive: ageCheckList[5],
                            action: {
                                focus = false
                                for i in stride(from: 0, through: ageCheckList.count - 1, by: 1) {
                                    ageCheckList[i] = false
                                }
                                ageCheckList[5].toggle()
                            }
                        )
                    })
                    
                }
            }
            Spacer()
            
            
            ButtonComponent(
                buttonType: .nextButton,
                content: "시작하기",
                isActive: nextButtonActivated,
                action: {
                    
                    CoreDataManager.coreDM.createUser(username: nameLimiter.value, age: findAgeOrGener(checkList: ageCheckList), gender: findAgeOrGener(checkList: genderActivatedList))
                    CoreDataManager.coreDM.createCharacter()
                    isFirstLaunch = false
                    print("데이터 저장됨")
                }
            )
            .disabled(!nextButtonActivated)
            
            
        }
        .padding(EdgeInsets(top: 30, leading: 40, bottom: 50, trailing: 40))
        .onChange(of: focus) { newValue in
            if !newValue {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
        
    }
    
    func findAgeOrGener(checkList: [Bool]) -> Int {
        for (index, i) in checkList.enumerated() {
            if i == true {
                return index
            }
        }
        return 0
    }
}

/**
 입력 글자 수를 제한하는 클래스
 */
class TextLimiter: ObservableObject {
    private let limit: Int
    
    init(limit: Int) {
        self.limit = limit
    }
    
    @Published var value = "" {
        didSet {
            if value.count > self.limit {
                value = String(value.prefix(self.limit))
                self.hasReachedLimit = true
            } else {
                self.hasReachedLimit = false
            }
            
        }
    }
    @Published var hasReachedLimit = false
}


struct DataReceiveView_Previewer: PreviewProvider {
    @State static var isFirstLaunch = false
    
    static var previews: some View {
        DataReceiveView(isFirstLaunch: $isFirstLaunch)
    }
}


//struct SampleView: View {
//    var body: some View {
//        Text("Hello World")
//            .textFontAndColor(.h7)
//    }
//}
//
//struct SampleView_Previewer: PreviewProvider {
//    static var previews: some View {
//        SampleView()
//    }
//}
