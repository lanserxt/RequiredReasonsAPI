//
//  ResultsList.swift
//  RequiredReasonAPIFinder
//
//  Created by Anton Gubarenko on 07.08.2023.
//

import SwiftUI

struct ResultsList: View {
    
    @Binding
    var matchedAPIs: [APIInfo]
    
    var body: some View {
        List(matchedAPIs, id: \.self) { item in
            VStack {
                Text(item.name)
                    .font(.headline)
                    .bold()
                    .padding(.top)
                    ForEach(item.reasons, id: \.self) { reason in
                        HStack {
                            Text(reason.id)
                                .bold()
                                .frame(width: 50)
                                .textSelection(.enabled)
                            Text(reason.info)
                                .multilineTextAlignment(.leading)
                                .textSelection(.enabled)
                            Spacer()
                        }.padding()
                    }
            }
            .background(Rectangle()
                .cornerRadius(8.0)
                .foregroundColor(.gray)
                .opacity(0.2)
            )
            .frame(minHeight: 30.0)
        }
    }
}

struct ResultsList_Previews: PreviewProvider {
    static var previews: some View {
        ResultsList(matchedAPIs: .constant([]))
    }
}
