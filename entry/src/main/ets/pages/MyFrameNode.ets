import { BuilderNode, FrameNode, NodeController, UIContext } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

//FrameNode表示了单个的自定义组件节点


@Builder
export function buttonBuilder(params: string) {
  Button(params)
    .fontSize(12)
    .borderRadius(8)
    .borderWidth(2)
    .backgroundColor(Color.Orange)
    .width("100%")
}


export class MyFrameNode extends NodeController {
  private buttonNode: BuilderNode<[string]> | null = null;
  private wrapBuilder: WrappedBuilder<[string]> = wrapBuilder(buttonBuilder);
  public rootFrameNode: FrameNode | null = null;

  //makeNode回调返回一个FrameNode节点树的根节点
  //然后将FrameNode 挂载到对应的NodeContainer下
  makeNode(uiContext: UIContext): FrameNode | null {

    if (this.rootFrameNode == null) {
      this.rootFrameNode = new FrameNode(uiContext);
      //设置属性
      this.rootFrameNode.commonAttribute
        .width("80%")
    }

    return this.rootFrameNode ? this.rootFrameNode : null;

  }

  addFrameNode() {

    //如果BuilderNode通过getFrameNode将节点挂载在另一个FrameNode上，或者将其作为子节点挂载在NodeContainer节点上。则节点中使用父组件的布局约束进行布局。
    //BuilderNode的预加载并不会减少组件的创建时间
    try {
      this.rootFrameNode?.appendChild(this.buttonNode?.getFrameNode());
      console.log(" appendChild success ");
    } catch (err) {
      console.log(" appendChild fail :" + (err as BusinessError).code + " : " + (err as BusinessError).message);
    }

  }

  removeFrameNode() {
    setTimeout(() => {
      try {
        this.rootFrameNode?.removeChild(this.buttonNode?.getFrameNode())
        console.log(" removeChild success ");
      } catch (err) {
        console.log(" removeChild fail : " + (err as BusinessError).code + " : " + (err as BusinessError).message);
      }
    }, 500)

  }

  initNode(str: string, uiContext: UIContext) {
    if (this.buttonNode != null) {
      return;
    }
    if (this.buttonNode == null) {
      this.buttonNode = new BuilderNode<[string]>(uiContext);
      this.buttonNode.build(this.wrapBuilder, str)
    }
  }

  onTouchEvent(event: TouchEvent): void {

  }



  disposeNode() {
    this.buttonNode?.dispose();
  }

  aboutToResize(size: Size) {

  }

  aboutToAppear() {
    if (this.buttonNode == undefined) {
      return;
    }
  }
}