//
//  DropView.swift
//  RequiredReasonAPIFinder
//
//  Created by Anton Gubarenko on 06.08.2023.
//

import SwiftUI

struct DropView: View {
    @Binding var fileURLs: [URL]
    
    var body: some View {
        Rectangle()
            .foregroundColor(.gray.opacity(0.2))
            .overlay(Text("Drag & Drop Folders Here"))
            .onDrop(of: [.fileURL], isTargeted: nil) { providers -> Bool in
                if let provider = providers.first(where: { $0.canLoadObject(ofClass: URL.self) } ) {
                    let _ = provider.loadObject(ofClass: URL.self) { object, error in
                        if let url = object {
                            if url.isDirectory {
                                DispatchQueue.main.async {
                                    fileURLs.append(url)
                                }
                            }
                        }
                    }
                    return true
                }
                return false
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .foregroundColor(Color.blue)
            )
            .frame(maxWidth: .infinity, maxHeight: 150)
            .padding()
    }
}

struct DropView_Previews: PreviewProvider {
    static var previews: some View {
        DropView(fileURLs: .constant([]))
    }
}
