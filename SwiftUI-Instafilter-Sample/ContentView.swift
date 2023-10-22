//
//  ContentView.swift
//  SwiftUI-Instafilter-Sample
//
//  Created by ekayaint on 16.10.2023.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    @State private var showingFilterSheet = false
    
    func save() {
        
    }
    
    func loadImage() {
        guard let inputImage = inputImage else {return}
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        
        guard let outputImage = currentFilter.outputImage else {return}
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
        }
    }
    
    func setFilter(_ filter: CIFilter){
        currentFilter = filter
        loadImage()
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                ZStack{
                    Rectangle()
                        .fill(.secondary)
                    
                    Text("Tab to select a picture")
                        .foregroundStyle(.white)
                        .font(.headline)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                    
                } //: ZStack
                .onTapGesture {
                    showingImagePicker = true
                }
                
                HStack{
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity) { _ in
                            applyProcessing()
                        }
                } //: HStack
                .padding(.vertical)
                
                HStack{
                    Button("Change Filter") {
                        showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save", action: save)
                } //: HStack
                
            } //: VStack
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .onChange(of: inputImage) { _ in
                loadImage()
            }
            .sheet(isPresented: $showingImagePicker, content: {
                ImagePicker(image: $inputImage)
            })
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                Button("Crystallize"){setFilter(CIFilter.crystallize())}
            }
        } //: Nav
        
    }
}

#Preview {
    ContentView()
}
