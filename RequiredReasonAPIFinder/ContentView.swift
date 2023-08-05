//
//  ContentView.swift
//  RequiredReasonAPIFinder
//
//  Created by Anton Gubarenko on 03.08.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State
    private var fileURLs: [URL] = []
    
    @State
    private var matchedURLs: [DetectedUsage] = []
    
    @State
    private var matchedAPIs: [APIInfo] = []
    
    @State
    private var apiInfoArray: [APIInfo] = []
    
    @State
    private var searchedOnce: Bool = false
    
    @State
    private var searchTask: Task<Void, Never>?
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Check API usage") {
                    searchTask?.cancel()
                    searchTask = Task(priority: .background) {
                        await searchWordInFiles()
                        searchedOnce = true
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                List(fileURLs, id: \.self) { url in
                    Text(url.path)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if !fileURLs.isEmpty {
                    Button(action: {
                        fileURLs.removeAll()
                        matchedAPIs.removeAll()
                        matchedURLs.removeAll()
                    }, label: {
                        Text("Clear all")
                    })
                }
                
                DropView(fileURLs: $fileURLs)
            }.frame(minWidth: 200.0)
            ResultsView(fileURLs: $fileURLs,
                        matchedURLs: $matchedURLs,
                        matchedAPIs: $matchedAPIs,
                        searchedOnce: $searchedOnce)
        }
        .onAppear {
            loadAPIInfo()
        }
        .padding()
        .navigationTitle("Reasoned API Finder")
    }
    
    private func searchWordInFiles() async {
        guard !Task.isCancelled else {return}
        for fileURL in fileURLs {
            guard !Task.isCancelled else {return}
            if fileURL.isDirectory {
                await searchWordInDirectory(fileURL)
            } else {
                await searchWordInFile(fileURL)
            }
        }
        matchedAPIs = Array(Set<APIInfo>.init(matchedURLs.compactMap({$0.api})))
    }
    
    private func searchWordInDirectory(_ directoryURL: URL) async  {
        guard !Task.isCancelled else {return}
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                guard !Task.isCancelled else {return}
                if fileURL.isDirectory {
                    await searchWordInDirectory(fileURL)
                } else {
                    await searchWordInFile(fileURL)
                }
            }
        } catch {
            print("Error reading directory: \(error.localizedDescription)")
        }
    }
    
    private func searchWordInFile(_ fileURL: URL) async {
        guard !Task.isCancelled else {return}
        do {
            let fileContent = try String(contentsOf: fileURL)
            
            print("Checking \(fileURL.lastPathComponent)")
            for api in apiInfoArray {
                if fileContent.containsAny(api.funcs) {
                    // Assuming the file contains the exact word 'getBuffSize'
                    matchedURLs.append(DetectedUsage(fileURL: fileURL, api: api))
                    print("Found \(api.name)")
                }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
