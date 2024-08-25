import { webview } from '@kit.ArkWeb'
import { systemDateTime } from '@kit.BasicServicesKit'
import { WebData } from '../bean/WebData'

const TAG="[NormalWebPage]"
@Component
export struct NormalWebPage {
  @Consume('appPathStack') appPathStack: NavPathStack
  private controller: WebviewController = new webview.WebviewController()
  @State url:string =""
  private startTime =0
  build() {
    NavDestination() {
      Web({ src: this.url, controller: this.controller })
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
        //网页首次内容绘制的回调函数。首次绘制文本、图像、非空白Canvva或者SVG的时间点。
        .onFirstContentfulPaint(() => {
          console.debug(TAG,"普通加载网页耗时："+ ( systemDateTime.getTime()-this.startTime))
        })
        .onAppear(()=>{
          this.startTime =systemDateTime.getTime()
        })
    }
    .onReady(()=>{
      let data= this.appPathStack.getParamByIndex(0) as WebData
      this.url =data.url
    })
    .title("普通加载网页")

  }
}