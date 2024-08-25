import { BuilderNode, FrameNode, NodeController, UIContext } from '@kit.ArkUI';
import { WebData } from '../bean/WebData';
import { webview } from '@kit.ArkWeb';
import { systemDateTime } from '@kit.BasicServicesKit';
import { NodeUtils } from './NodeUtils';

const TAG = "[WebNode]"

@Builder
export function webBuilder(params: WebData) {
  Web({ src: params.url, controller: new webview.WebviewController() })
    .domStorageAccess(true)
    .zoomAccess(true)
    .fileAccess(true)
    .mixedMode(MixedMode.All)
    .cacheMode(CacheMode.Default)
    .verticalScrollBarAccess(false)
    .javaScriptAccess(true)
    .pinchSmooth(true)
    .width('100%')
    .height('100%')
    .onPageEnd(() => {
      // console.debug("onPageEnd 耗时："+ ( systemDateTime.getTime()-this.startTime))
    })//网页首次内容绘制的回调函数。首次绘制文本、图像、非空白Canvva或者SVG的时间点。
    .onFirstContentfulPaint(() => {
      console.debug("动态加载网页耗时：" + (systemDateTime.getTime() - params.startTime))
    })
    .onAppear(() => {
      params.startTime = systemDateTime.getTime()
    })
}




export class WebNode extends NodeController {
  private rootNode: BuilderNode<WebData[]> | null | undefined = null;
  private wrap = wrapBuilder<WebData[]>(webBuilder);
  makeNode(uiContext: UIContext): FrameNode | null {

    if (this.rootNode != undefined) {
      console.info(TAG, "makeNode");

      return this.rootNode.getFrameNode();
    }
    return null;
  }

  disposeNode() {
    this.rootNode?.dispose();
  }

  aboutToResize(size: Size) {
    console.info(TAG, 'aboutToResize width : ' + size.width + ' height : ' + size.height);
  }

  aboutToAppear() {
    if (this.rootNode == undefined) {
      return;
    }
  }

  aboutToDisappear() {
    console.info(TAG, 'aboutToDisappear');
  }

  initWeb(data: WebData, uiContext: UIContext) {
    console.info(TAG, "initWeb");
    if (this.rootNode != null) {
      return;
    }
    this.rootNode = new BuilderNode(uiContext);
    this.rootNode.dispose()
    this.rootNode.build(this.wrap, data);
  }
}


export function createNWeb(data: WebData, uiContext?: UIContext) {
  if (NodeUtils.nodeMap.has(NodeUtils.WEB)) {
    return;
  }

  if (uiContext != undefined) {
    let baseNode = new WebNode();
    baseNode.initWeb(data, uiContext);
    NodeUtils.nodeMap.set(NodeUtils.WEB, baseNode);
  }

}

export const getNWeb = (): NodeController | undefined => {
  return NodeUtils.nodeMap.get(NodeUtils.WEB);
}

