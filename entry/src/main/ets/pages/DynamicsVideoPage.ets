import { VideoData } from '../bean/VideoData'
import { getNVideo, replaceBuilderVideo } from '../uinode/VideoNode'
import { systemDateTime } from '@kit.BasicServicesKit'
import { common } from '@kit.AbilityKit'
import { NodeUtils } from '../uinode/NodeUtils'
import { TextComponent } from '../view/TextComponent'


@Component
export struct DynamicsVideoPage {
  @Consume('appPathStack') appPathStack: NavPathStack
  private videoSrc: Resource[] = [$rawfile('a1.mp4'), $rawfile('a3.mp4')]
  voidData?: VideoData
  index: number = 0
  @State startTime: number = 0
  @State playTime: number = 0
  private context = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {

    this.context.eventHub.on(NodeUtils.PLAYTIME, (event: number) => {
      this.playTime = event
    })
    this.context.eventHub.on(NodeUtils.STARTTIME, (event: number) => {
      this.startTime = event
    })
  }

  build() {
    NavDestination() {
      Column() {
        NodeContainer(getNVideo())
        Button('Next Video')
          .onClick(() => {
            this.index++
            let data: VideoData = new VideoData(this.videoSrc, undefined, systemDateTime.getTime(), this.index % 2)
            replaceBuilderVideo(data, this.getUIContext())
          })
          .margin(20)
          .width('100%')

        TextComponent({msg1:this.startTime,msg2: this.playTime,msg3:(this.playTime-this.startTime)})
      }
      .width('100%')
      .height('100%')
    }
    .onReady(() => {
      this.voidData = this.appPathStack.getParamByIndex(0) as VideoData
    })
    .title("动态加载网页")

  }
}