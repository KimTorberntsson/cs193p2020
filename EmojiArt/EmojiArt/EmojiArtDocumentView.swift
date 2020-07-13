//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Kim Torberntsson on 2020-06-26.
//  Copyright © 2020 Kim Torberntsson. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    @State var chosenPalette : String = ""
    
    init(document: EmojiArtDocument) {
        self.document = document
        _chosenPalette = State(wrappedValue: self.document.defaultPalette)
    }
    
    var body: some View {
        VStack {
            HStack {
                PaletteChooser(document: document, chosenPalette: $chosenPalette)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(chosenPalette.map { String($0) }, id: \.self) { emoji in
                            Text(emoji)
                                .font(Font.system(size: self.defaultEmojiSize))
                                .onDrag { NSItemProvider(object: emoji as NSString) }
                        }
                    }
                }
            }
            GeometryReader { geometry in
                ZStack {
                    Color.white.overlay(
                        OptionalImage(uiImage: self.document.backgroundImage)
                            .scaleEffect(self.zoomScale)
                            .offset(self.panOffset)
                    )
                    if self.isLoading {
                        Image(systemName: "hourglass").imageScale(.large).spinning()
                    } else {
                        ForEach(self.document.emojis) { emoji in
                            self.body(for: emoji, in: geometry.size)
                        }
                    }
                }
                .clipped()
                .gesture(self.panGesture())
                .gesture(self.zoomGesture())
                .gesture(self.backgroundTapGestures(in: geometry.size))
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onReceive(self.document.$backgroundImage) { image in
                    self.zoomToFit(image, in: geometry.size)
                }
                .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                    var location = geometry.convert(location, from: .global)
                    location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                    location = CGPoint(x: location.x - self.panOffset.width, y: location.y - self.panOffset.height)
                    location = CGPoint(x: location.x / self.zoomScale, y: location.y / self.zoomScale)
                    return self.drop(providers: providers, at: location)
                }
                .navigationBarItems(trailing: Button(action: {
                    if let url = UIPasteboard.general.url, url != self.document.backgroundURL {
                        self.confirmBackgroundPaste = true
                    } else {
                        self.explainBackgroundPaste = true
                    }
                }, label: {
                    Image(systemName: "doc.on.clipboard").imageScale(.large)
                        .alert(isPresented: self.$explainBackgroundPaste) {
                            return Alert(
                                title: Text("Paste Background"),
                                message: Text("Copy the URL of an image to the clip board and touch this button to make it the background of your document"),
                                dismissButton: .default(Text("OK")))
                    }
                }))
            }
        .zIndex(-1)
            .alert(isPresented: self.$confirmBackgroundPaste) {
                Alert(
                    title: Text("Paste Background"),
                    message: Text("Replace your background with \(UIPasteboard.general.url?.absoluteString ?? "nothing")?."),
                    primaryButton: .default(Text("OK")) {
                        self.document.backgroundURL = UIPasteboard.general.url
                    }, secondaryButton: .cancel()
                )
            }
        }
    }
    
    @State private var explainBackgroundPaste = false
    @State private var confirmBackgroundPaste = false
    
    func body(for emoji: EmojiArt.Emoji, in size: CGSize) -> some View {
        Text(emoji.text)
            .font(animatableWithSize: emoji.fontSize * zoomScale(for: emoji))
            .padding(emojiSelectionPadding)
            .border(Color.black, width: emojiSelected(emoji) ? emojiSelectionWidth : 0)
            .position(position(for: emoji, in: size))
            .offset(offset(for: emoji))
            .gesture(panGesture(for: emoji))
            .gesture(tapGesture(for: emoji))
            .gesture(longPressGesture(for: emoji))
    }
    
    private var isLoading: Bool {
        document.backgroundURL != nil && document.backgroundImage == nil
    }
    
    private func backgroundTapGestures(in size: CGSize) -> some Gesture {
        TapGesture(count: 2).onEnded {
            withAnimation {
                self.zoomToFit(self.document.backgroundImage, in: size)
            }
        }
        .exclusively(before:
            TapGesture(count: 1)
                .onEnded {
                    self.document.deselectEmojis()
            }
        )
    }
    
    private func tapGesture(for emoji: EmojiArt.Emoji) -> some Gesture {
        TapGesture(count: 1)
            .onEnded {
                self.document.toggleSelection(of: emoji)
        }
    }
    
    private func longPressGesture(for emoji: EmojiArt.Emoji) -> some Gesture {
        LongPressGesture()
            .onEnded { _ in
                self.document.remove(emoji)
        }
    }
    
    @GestureState private var gesturePanOffset: CGSize = .zero
    
    private var panOffset: CGSize {
        (document.steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { (latestDragGestureValue, gesturePanOffset, transaction) in
                gesturePanOffset = latestDragGestureValue.translation / self.zoomScale
        }
        .onEnded { finalDragGestureValue in
            self.document.steadyStatePanOffset = self.document.steadyStatePanOffset + (finalDragGestureValue.translation / self.zoomScale)
        }
    }
    
    private func offset(for emoji: EmojiArt.Emoji) -> CGSize {
        if let draggedEmoji = document.draggedEmoji {
            if emojiSelected(draggedEmoji) {
                if emojiSelected(emoji) {
                    // We are dragging a selected emoji and our emoji is selected.
                    return gestureEmojiPanOffset
                }
            } else {
                if draggedEmoji.id == emoji.id {
                    // We are dragging a unselected emoji and our emoji is that emoji.
                    return gestureEmojiPanOffset
                }
            }
        }
        
        return CGSize.zero
    }
    
    @GestureState private var gestureEmojiPanOffset: CGSize = .zero
    
    private func panGesture(for emoji: EmojiArt.Emoji) -> some Gesture {
        DragGesture()
            .updating($gestureEmojiPanOffset) { (latestDragGestureValue, gestureEmojiPanOffset, transaction) in
                if self.document.draggedEmoji == nil {
                    self.document.draggedEmoji = emoji
                }
                gestureEmojiPanOffset = latestDragGestureValue.translation
        }
        .onEnded { finalDragGestureValue in
            if let draggedEmoji = self.document.draggedEmoji {
                let translation = finalDragGestureValue.translation / self.zoomScale
                if self.emojiSelected(draggedEmoji) {
                    for emoji in self.document.selectedEmojis {
                        self.document.moveEmoji(emoji: emoji, by: translation)
                    }
                } else {
                    self.document.moveEmoji(emoji: draggedEmoji, by: translation)
                }
                
                self.document.draggedEmoji = nil
            }
            
        }
    }
    
    @GestureState private var gestureMagnificationScale: CGFloat = 1.0
    
    private func zoomScale(for emoji: EmojiArt.Emoji) -> CGFloat {
        if emojiSelected(emoji) {
            // Gesture is used for resizing emoji
            return zoomScale * gestureMagnificationScale
        } else {
            // Gesture is used for zooming
            return zoomScale
        }
    }
    
    private var zoomScale: CGFloat {
        if emojiAreSelected {
            // Gesture is used for resizing emoji
            return document.steadyStateZoomScale
        } else {
            // Gesture is used for zooming
            return document.steadyStateZoomScale * gestureMagnificationScale
        }
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureMagnificationScale) { (latestGestureScale, gestureZoomScale, transaction) in
                gestureZoomScale = latestGestureScale
        }
        .onEnded { finalGestureScale in
            if self.emojiAreSelected {
                for emoji in self.document.selectedEmojis {
                    self.document.scaleEmoji(emoji: emoji, by: finalGestureScale)
                }
            } else {
                self.document.steadyStateZoomScale *= finalGestureScale
            }
        }
    }
    
    private var emojiAreSelected: Bool {
        self.document.selectedEmojis.count > 0
    }
    
    private func emojiSelected(_ emoji: EmojiArt.Emoji) -> Bool {
        self.document.selectedEmojis.contains(matching: emoji)
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0, size.height > 0, size.width > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.width
            self.document.steadyStatePanOffset  = .zero
            self.document.steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
    
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint(x: location.x + size.width/2, y:  location.y + size.height/2)
        location = CGPoint(x: location.x + self.panOffset.width, y: location.y + self.panOffset.height)
        return location
    }
    
    private func drop(providers:  [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            print("Dropped \(url)")
            self.document.backgroundURL = url
        }
        if !found {
            found = providers.loadFirstObject(ofType: String.self) { string in
                self.document.addEmoji(emoji: string, at: location, size: self.defaultEmojiSize)
            }
        }
        return found
    }
    
    let defaultEmojiSize: CGFloat = 40
    let emojiSelectionPadding: CGFloat = 4
    let emojiSelectionWidth: CGFloat = 2
}

struct EmojiArtDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
    }
}
