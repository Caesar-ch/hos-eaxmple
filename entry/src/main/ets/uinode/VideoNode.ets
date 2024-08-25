import { VideoData } from '../bean/VideoData'
import { image } from '@kit.ImageKit';
import { systemDateTime } from '@kit.BasicServicesKit';
import { BuilderNode, FrameNode, NodeController, Size, UIContext } from '@kit.ArkUI';
import { NodeUtils } from './NodeUtils';


const TAG = "[VideoNode]"


let pixelMap: image.PixelMap | undefined = undefined;


@Builder
export function videoBuilder(params: VideoData) {

  Video({
    src: params.getVideoUrl(),
    currentProgressRate: PlaybackSpeed.Speed_Forward_1_00_X,
    controller: params.controller,
    previewUri: pixelMap
  })
    .aspectRatio(1.6)
    .onStart(() => {
      console.debug(TAG, "开始播放时间：" + systemDateTime.getTime())
      console.debug(TAG, "起播耗时：" + (systemDateTime.getTime() - params.startTime!!))
      getContext().eventHub.emit(NodeUtils.PLAYTIME, systemDateTime.getTime())
    })
    .onAppear(() => {
      console.debug(TAG, "onAppear：" + systemDateTime.getTime())
      params.startTime = systemDateTime.getTime()
      getContext().eventHub.emit(NodeUtils.STARTTIME, systemDateTime.getTime())
    })
    .onPrepared((event)=>{
      if(params.startTime!=0){
        params.controller.start()
        console.debug(TAG, "onPrepared：" + event.duration)
      }

    })


}

export class VideoNode extends NodeController {
  private rootNode: BuilderNode<VideoData[]> | null | undefined = null;
  private wrap = wrapBuilder<VideoData[]>(videoBuilder);
  private data?: VideoData

  makeNode(uiContext: UIContext): FrameNode | null {
    if (this.rootNode != undefined) {
      console.info(TAG, "makeNode");
      return this.rootNode.getFrameNode();
    }
    return null;
  }

  aboutToAppear(): void {
    console.info(TAG, "aboutToAppear");
    this.data?.controller.start()
  }

  aboutToResize(size: Size): void {
    console.info(TAG, "aboutToResize width:" + size.width + " height:" + size.height);
  }

  aboutToDisappear(): void {
    console.info(TAG, "aboutToDisappear");
  }

  dispose() {
    this.rootNode?.dispose()
  }

  initVideo(data: VideoData, uiContext: UIContext) {
    console.info(TAG, "initVideo");
    if (this.rootNode != null) {
      return;
    }
    this.data = data
    this.rootNode = new BuilderNode(uiContext);
    this.rootNode.dispose()
    this.rootNode.build(this.wrap, data);
  }


  replaceBuilderNode(data: VideoData, uiContext: UIContext) {
    console.info(TAG, "replaceBuilderNode");
    this.data = data
    this.rootNode = new BuilderNode(uiContext);
    this.rootNode.dispose()
    this.rootNode.build(this.wrap, data);
    // rebuild方法会重新调用makeNode方法
    this.rebuild();
  }

  update(data: VideoData){

    this.rootNode?.update(data)
  }
}


export function createNVideo(data: VideoData, uiContext?: UIContext) {
  if (NodeUtils.nodeMap.has(NodeUtils.VIDEO)) {
    return;
  }

  if (uiContext != undefined) {
    let baseNode = new VideoNode();
    baseNode.initVideo(data, uiContext);
    NodeUtils.nodeMap.set(NodeUtils.VIDEO, baseNode);
  }
}


export function replaceBuilderVideo(data: VideoData, uiContext?: UIContext) {
  if (NodeUtils.nodeMap.has(NodeUtils.VIDEO)) {
    (NodeUtils.nodeMap.get(NodeUtils.VIDEO) as VideoNode).dispose()

    if (uiContext != undefined) {
      (NodeUtils.nodeMap.get(NodeUtils.VIDEO) as VideoNode).replaceBuilderNode(data, uiContext)
    }
  } else {
    createNVideo(data, uiContext)
  }

}


export function updateBuilderVideo(data: VideoData) {
  if (NodeUtils.nodeMap.has(NodeUtils.VIDEO)) {
    (NodeUtils.nodeMap.get(NodeUtils.VIDEO) as VideoNode).update(data)
  }
}


export const getNVideo = (): NodeController | undefined => {
  return NodeUtils.nodeMap.get(NodeUtils.VIDEO)
}

