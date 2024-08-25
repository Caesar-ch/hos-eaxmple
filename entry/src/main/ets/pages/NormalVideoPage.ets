import { image } from '@kit.ImageKit'
import { media } from '@kit.MediaKit'
import { systemDateTime } from '@kit.BasicServicesKit'
import { VideoData } from '../bean/VideoData'
import { TextComponent } from '../view/TextComponent'

const TAG = "[NormalVideoPage]"

@Component
export struct NormalVideoPage {
  @Consume('appPathStack') appPathStack: NavPathStack
  @State startTime:number = 0
  @State playTime:number=0
  index: number = 0
  data: VideoData = new VideoData()
  @State videoUrl: ResourceStr = ""
  //1倍速播放。
  curRate: PlaybackSpeed = PlaybackSpeed.Speed_Forward_1_00_X
  controller: VideoController = new VideoController()
  @State pixelMap: image.PixelMap | undefined = undefined;
  @State currentTime: number = 0;
  @State durationTime: number = 0;

  build() {
    NavDestination() {
      Column() {
        Video({
          src: this.videoUrl,
          currentProgressRate: this.curRate,
          controller: this.controller,
          previewUri: this.pixelMap
        })
          .aspectRatio(1.6)
          .onAppear(() => {
            // setTimeout(() => {
            //   this.testFetchFrameByTime()
            // }, 50)
          })
          .autoPlay(true)

          .onPrepared((event) => {
            if (event) {
              this.durationTime = event.duration
            }
            console.debug(TAG, "onPrepared：" + event.duration)
          })
          .onSeeking((event) => {
            if (event) {
              this.currentTime = event.time
            }
          })//播放进度变化时触发该事件
          .onUpdate((event) => {
            if (event) {
              this.currentTime = event.time
            }
          })
          .onStart(() => {
            this.playTime=systemDateTime.getTime()
            console.debug(TAG, "开始播放时间：：" + systemDateTime.getTime())
            console.debug(TAG, "起播耗时：" + (systemDateTime.getTime() - this.startTime))

          })
          .onAppear(() => {
            console.debug(TAG, "onAppear：" + systemDateTime.getTime())
            this.startTime = systemDateTime.getTime()
          })

        Button('Next Video')
          .onClick(() => {
            this.index++
            this.videoUrl = this.data.videoSrc!![this.index%2]

          }).margin(20)
          .width('100%')
        TextComponent({msg1:this.startTime,msg2: this.playTime,msg3:(this.playTime-this.startTime)})
      }
      .width('100%')
      .height('100%')
    }.onReady(() => {
      this.data = this.appPathStack.getParamByIndex(0) as VideoData
      if (this.data.videoUrl != undefined) {
        this.videoUrl = this.data.videoUrl
      }
      if (this.data.videoSrc != undefined) {
        this.videoUrl = this.data.videoSrc[this.index]
      }
    })
    .title("普通加载视频")
  }

  // 在以下demo中，使用资源管理接口获取打包在HAP内的视频文件，通过设置fdSrc属性，
  async testFetchFrameByTime() {
    // 创建AVImageGenerator对象
    try {
      let avImageGenerator: media.AVImageGenerator = await media.createAVImageGenerator()
      // 设置fdSrc
      avImageGenerator.fdSrc = await getContext(this).resourceManager.getRawFd('a1.mp4');
      // 初始化入参
      let timeUs = 0
      let queryOption = media.AVImageQueryOptions.AV_IMAGE_QUERY_NEXT_SYNC
      let param: media.PixelMapParams = {
        width: 1080,
        height: 200
      }
      // 获取缩略图（promise模式）
      this.pixelMap = await avImageGenerator.fetchFrameByTime(timeUs, queryOption, param)
      // 释放资源（promise模式）
      avImageGenerator.release()
    } catch (e) {
      console.debug("e:" + e)
    }

  }
}