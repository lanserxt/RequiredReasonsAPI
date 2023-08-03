//
//  ContentView.swift
//  RequiredReasonAPIFinder
//
//  Created by Anton Gubarenko on 03.08.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var fileURLs: [URL] = []
    @State private var matchedURLs: [URL] = []
    
    @State
    private var apiInfoArray: [APIInfo] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    searchWordInFiles()
                }, label: {
                    Text("Check API usage")
                        .lineLimit(-1)
                        .multilineTextAlignment(.leading)
                })
                .padding()
                
                List(fileURLs, id: \.self) { url in
                    Text(url.path)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                DropView(fileURLs: $fileURLs)
            }.frame(minWidth: 200.0)
            
            if !matchedURLs.isEmpty {
                Group {
                    Text("Matching Files:")
                    List(fileURLs, id: \.self) { url in
                        Text(url.lastPathComponent)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Group {
                    Text("No plist changes reqiured")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            loadAPIInfo()
        }
        .padding()
        .navigationTitle("Drag & Drop App")
    }
    
    private func searchWordInFiles() {
        for fileURL in fileURLs {
            if fileURL.isDirectory {
                searchWordInDirectory(fileURL)
            } else {
                searchWordInFile(fileURL)
            }
        }
    }
    
    private func searchWordInDirectory(_ directoryURL: URL) {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                if fileURL.isDirectory {
                    searchWordInDirectory(fileURL)
                } else {
                    searchWordInFile(fileURL)
                }
            }
        } catch {
            print("Error reading directory: \(error.localizedDescription)")
        }
    }
    
    private func searchWordInFile(_ fileURL: URL) {
        do {
            let fileContent = try String(contentsOf: fileURL)
            if fileContent.contains("getBuffSize") {
                // Assuming the file contains the exact word 'getBuffSize'
                matchedURLs.append(fileURL)
            }
        } catch {
            print("Error reading file: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Load Data
    
    private func loadAPIInfo() {
        // Get the URL for the JSON file in the app bundle
        if let url = Bundle.main.url(forResource: "APIReasons", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: url)
                apiInfoArray = try JSONDecoder().decode([APIInfo].self, from: jsonData)
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("JSON file not found in the bundle.")
        }
    }
}

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

extension URL {
    var isDirectory: Bool {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
