//
//  ResultsCode.swift
//  RequiredReasonAPIFinder
//
//  Created by Anton Gubarenko on 07.08.2023.
//

import SwiftUI
import UniformTypeIdentifiers

struct ResultsCode: View {
    
    @Binding
    var matchedAPIs: [APIInfo]
    
    @State
    var code: String = "When text is selected, the user automatically gains access to the regular text actions such as Copy and Share. However, right now at least the whole text area is copied – you don’t get a text selection loupe, so you can’t select just a few words.\nSetting textSelection() on any kind of group of views will automatically make all text inside that group selectable. For example, we could make both text views in our previous example selectable by moving the modifier up to the stack:"
    var body: some View {
        ZStack {
            GeometryReader { geo in
                ScrollView {
                    VStack(alignment: .leading) {
                            Text(code)
                                .multilineTextAlignment(.leading)
                                .textSelection(.enabled)
                                .padding()
                                .background(Rectangle().foregroundColor(.white))
                    }
                }
            }
            VStack {
                HStack {
                    Spacer()
                    Button {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.writeObjects([code as NSString])
                    } label: {
                        Image(systemName: "doc.on.doc")
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .background(Rectangle().foregroundColor(.white)).onAppear {
            codeGeneration()
        }
    }
    
    private func codeGeneration() {
        var codeStr = ""
        codeStr.append("<dict>\n<key>NSPrivacyCollectedDataTypes</key>\n\t<array>")
        for api in matchedAPIs {
            codeStr.append("\n\(String(repeating: "\t", count: 2))<dict>\n")
            
            codeStr.append("\(String(repeating: "\t", count: 3))<key>NSPrivacyAccessedAPIType</key>")
            codeStr.append("\n\(String(repeating: "\t", count: 3))<string>\(api.apiType)</string>")
            
            codeStr.append("\n\(String(repeating: "\t", count: 4))<key>NSPrivacyAccessedAPITypeReasons</key>")
            codeStr.append("\n\(String(repeating: "\t", count: 4))<array>\(api.reasons.compactMap({"<string>\($0.id)</string>"}).joined(separator: "\n"))</array>")
            
            codeStr.append("\n\(String(repeating: "\t", count: 3))</dict>")
        }
        codeStr.append("\n\(String(repeating: "\t", count: 2))</array>\n</dict>")
        code = codeStr
    }
}

struct ResultsCode_Previews: PreviewProvider {
    static var previews: some View {        
        ResultsCode(matchedAPIs: .constant([]))
    }
}
