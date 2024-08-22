//
//  Examples.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//

import SwiftUI

struct BoxPrintView: View {
  
  var body: some View {
    
    VStack(spacing: 30) {
      
      VStack{
        Text(ConsoleOutput.drawBox(
          header: "It's a header",
          content: TestStrings.paragraphs[1].preview(300),
          config: Config(theme: .sharp, width: 60, headerLineLimit: 0, contentLineLimit: 10)
        ))
      }
      //      HStack {
      //        VStack{
      //          Text("Width: 20")
      //          Text(ConsoleOutput.reflowText(TestStrings.paragraphs[0], width: 20).joined)
      //        }
      //
      //        VStack{
      //          Text("Width: 40")
      //          Text(ConsoleOutput.reflowText(TestStrings.paragraphs[2], width: 40).joined)
      //        }
      //
      //      }
      //
      //      VStack{
      //        Text("Width: 40")
      //        Text(ConsoleOutput.draw(
      //          header: "It's a header",
      //          content: TestStrings.paragraphs[1],
      //          width: 40
      //        ))
      //      }
//      HStack {
////        Text(ConsoleOutput)
//        
//        Text(TestStrings.paragraphs[1].preview(300))
//        
//      }
      .textSelection(.enabled)
    }
    .monospaced()
    .padding(40)
    .frame(width: 600, height: 300)
    .background(.black.opacity(0.6))
    
  }
}

extension BoxPrintView {
  
}


#Preview {
  BoxPrintView()
}

