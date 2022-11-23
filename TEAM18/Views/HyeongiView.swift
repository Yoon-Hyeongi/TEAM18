//
//  HyeongiView.swift
//  TEAM18
//
//  Created by 서광현 on 2022/11/23.
//

import SwiftUI

// Date형식 변경하는 메소드
func updateDateFormat(timeInterval: Int) -> String {
    let date: Date = Date(timeIntervalSince1970: TimeInterval(timeInterval / 1000))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd"             // ex)2020.08.13
    let dateString = dateFormatter.string(from: date)   // 현재 시간의 Date를 format에 맞춰 string으로 반환
    
    return dateString
}

// 타이틀 데이터에 존재하는 유니코드들 치환
func updateTitleFormat(title: String) -> String {
    let updateTitle: String = title
        .replacingOccurrences(of: "&#39;", with: "'")
        .replacingOccurrences(of: "&#40;", with: "(")
        .replacingOccurrences(of: "&#41;", with: ")")
        .replacingOccurrences(of: "&#8211;", with: "–")
        .replacingOccurrences(of: "&#8228;", with: "․")
        .replacingOccurrences(of: "&#8231;", with: "‧")
        .replacingOccurrences(of: "&#9642;", with: "▪")
        .replacingOccurrences(of: "&#10122;", with: "➊")
        .replacingOccurrences(of: "&#10123;", with: "➋")
        .replacingOccurrences(of: "&#10124;", with: "➌")
        .replacingOccurrences(of: "&#65378;", with: "｢")
        .replacingOccurrences(of: "&#65379;", with: "｣")
        .replacingOccurrences(of: "&lt;", with: "<")
        .replacingOccurrences(of: "&gt;", with: ">")
    
    return updateTitle
}

struct HyeongiView: View {
    @ObservedObject var dataStore: DataStore = DataStore(dataForm: [])
    
    var webService: WebService = WebService()
    
    @State private var currentPage: Int = 1
    
    var body: some View {
        NavigationStack {   // stack 이따 지우자
            
            VStack {
                List {
                    ForEach(Array(zip(dataStore.dataForm.indices, dataStore.dataForm)), id: \.0) { index, data in
                        if  index > 10 * (currentPage - 1) && index < 10 * currentPage {
                            NavigationLink(destination: HyeongiDetailView(data: data)) {
                                VStack(alignment: .leading) {
                                    
                                    // 데이터에 존재하는 유니코드 문자들 수정
                                    let title: String = updateTitleFormat(title: data.n_title)
                                    
                                    // 타이틀
                                    Text("\(title)")
                                        .font(.headline)
                                        .lineLimit(1)
                                        .padding(.bottom, 1)
                                    HStack{
                                        HStack{
                                            Image(systemName: "eye")
                                            Text("\(data.n_view_count)")
                                        }
                                        
                                        HStack {
                                            Image(systemName: "calendar")
                                            let dateString: String = updateDateFormat(timeInterval: data.reg_date)
                                            Text("\(dateString)")
                                        }
                                    }
                                    .font(.caption)
                                    .foregroundColor(.indigo)
                                }
                            }
                        }
                    }
                }   // List end
                .navigationTitle("서울시 물가 소식정보")
                .onAppear {
                    Task {
                        currentPage = 1
                        dataStore.dataForm = try await webService.fetchData현기(url: URLS.현기님)
                    }
                }
                
                HStack {
                    Button(action: {
                        guard currentPage < 2 else {
                            currentPage -= 1
                            return
                        }
                    }) {
                        Image(systemName: "lessthan.square.fill")
                            .font(.title)
                    }
                    
                    Text("\(currentPage)")
                        .padding(.horizontal)
                        .font(.title)
                    
                    Button(action: {
                        currentPage += 1
                    }) {
                        Image(systemName: "greaterthan.square.fill")
                            .font(.title)
                    }
                } // HStack end
                
            } // VStack end
            
        } // 여기
    }
}

struct HyeongiDetailView: View {
    
    let data: DataForm
    var body: some View {
        List {
            Section("제목") {
                VStack(spacing: 15) {
                    HStack {
                        let title: String = updateTitleFormat(title: data.n_title)
                        Text("\(title)")
                            .font(.headline)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        HStack{
                            Image(systemName: "eye")
                            Text("\(data.n_view_count)")
                        }
                        
                        Text("/")
                        
                        HStack {
                            Image(systemName: "calendar")
                            let dateString: String = updateDateFormat(timeInterval: data.reg_date)
                            Text("\(dateString)")
                        }
                    }
                    .font(.caption)
                }
            }
            
            Section("내용") {
                let content: String = updateTitleFormat(title: data.n_contents)
                Text("\(content)")
                    .font(.subheadline)
            }
        }
        .listStyle(.insetGrouped)
    }
}


struct HyeongiView_Previews: PreviewProvider {
    static var previews: some View {
        HyeongiView()
    }
}
