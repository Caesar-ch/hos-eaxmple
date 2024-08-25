import { MyFrameNode } from './MyFrameNode';
import { NormalVideoPage } from './NormalVideoPage';
import { NormalWebPage } from './NormalWebPage';
import { systemDateTime } from '@kit.BasicServicesKit';
import { WebData } from '../bean/WebData';
import { DynamicsWebPage } from './DynamicsWebPage';
import { createNWeb } from '../uinode/WebNode';
import { DynamicsVideoPage } from './DynamicsVideoPage';
import { VideoData } from '../bean/VideoData';
import { createNVideo } from '../uinode/VideoNode';

@Entry
@Component
struct Index {
  @State message: string = '动态自定义节点';
  private myNodeController: MyFrameNode = new MyFrameNode();
  @Provide('appPathStack') appPathStack: NavPathStack = new NavPathStack();

  private src = "https://developer.huawei.com/consumer/cn/"
  private videoSrc: Resource[] = [$rawfile('a1.mp4'), $rawfile('a3.mp4')]
  data:VideoData = new VideoData(this.videoSrc,undefined,systemDateTime.getTime(),0)
  @Builder
  PagesMap(name: string) {
    if (name == 'NormalWebPage') {
      NormalWebPage()
    }
    else if(name == 'NormalVideoPage'){
      NormalVideoPage()
    }
    else if(name=="DynamicsWebPage"){
      DynamicsWebPage()
    }
    else if(name=="DynamicsVideoPage"){
      DynamicsVideoPage()
    }
  }


  build() {
    Navigation(this.appPathStack) {
      Column({space:20}){
        Text(this.message)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .width('80%')
          .margin({top:30})


        Button("普通跳转网页")
          .btnFancy()
          .onClick(()=>{
            this.appPathStack.pushPathByName('NormalWebPage', new WebData(systemDateTime.getTime(),this.src));})


        Button("预加载网页")
          .btnFancy()
          .onClick(()=>{
            console.debug("跳转动态加载网页: "+  systemDateTime.getTime())
            let data =new WebData(systemDateTime.getTime(),this.src)
            this.appPathStack.pushPathByName('DynamicsWebPage', data);
          })
          .onAppear(()=>{
            let data =new WebData(systemDateTime.getTime(),this.src)
            createNWeb(data,this.getUIContext())
          })


        Button("普通视频页")
          .btnFancy()
          .onClick(()=>{
            this.appPathStack.pushPathByName('NormalVideoPage', new VideoData(this.videoSrc,undefined,systemDateTime.getTime()));
          })

        Button("动态视频页")
          .btnFancy()
          .onClick(()=>{
            this.appPathStack.pushPathByName('DynamicsVideoPage',this.data);
          })
          .onAppear(()=>{
            createNVideo(this.data,this.getUIContext())
          })



        //自定义节点 占位
        NodeContainer(this.myNodeController)
        // .width("100%")
        // .height("40%")

        Button("addNode")
          . btnFancy()
          .borderRadius(8)
          .borderWidth(2)
          .backgroundColor(Color.Blue)
          .onClick(()=>{
            this.myNodeController.addFrameNode()
          })

        Button("removeNode")
          . btnFancy()
          .borderRadius(8)
          .borderWidth(2)
          .backgroundColor(Color.Gray)
          .onClick(()=>{
            this.myNodeController.removeFrameNode()
          })


      }
      // .alignItems(HorizontalAlign.Center)
      .height('100%')
      .width('100%')
    }.onAppear(()=>{
      this.myNodeController.initNode("被添加的节点",this.getUIContext())
    }) .navDestination(this.PagesMap)

  }


}
@Extend(Button)
function btnFancy (){
  .width('80%')
  .fontSize(16)
}