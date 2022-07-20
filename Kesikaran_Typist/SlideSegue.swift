//
//  SlideSegue.swift
//  Kesikaran_Typist
//
//  Created by Tomishige Ryosuke on 2022/01/28.
//  https://qiita.com/morikiyo/items/64fc525cb10fa04eb559

import Cocoa

class SlideSegue: NSStoryboardSegue {
  override func perform() {
    // NSViewControllerの親子関係を設定
    guard
      let s = self.sourceController as? NSViewController,
      let d = self.destinationController as? ViewController,
      let p = s.parent
    else {
      print("downcasting or unwrapping error")
      return
    }

    if (!p.children.contains(d)) {
      p.addChild(d)
    }

    // 遷移アニメーション
    NSAnimationContext.runAnimationGroup(
      { context in
        context.duration = 0.5

        var frame = s.view.frame
        frame.origin.x = frame.size.width;
        d.view.frame = frame;
        s.view.superview?.addSubview(d.view)

        let newDFrame = s.view.frame

        var newSFrame = s.view.frame
        newSFrame.origin.x = -newSFrame.size.width

        s.view.animator().frame = newSFrame
        d.view.animator().frame = newDFrame

        d.view.autoresizingMask = s.view.autoresizingMask // Storyboard で適切に設定されているなら不要かも

      }, completionHandler: {
        s.removeFromParent() // 戻る可能性があるなら不要かも
        s.view.removeFromSuperview()
      }
    )
  }
}
