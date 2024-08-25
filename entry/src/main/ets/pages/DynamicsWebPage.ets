import { WebData } from '../bean/WebData'
import { getNWeb } from '../uinode/WebNode'



@Component
export struct DynamicsWebPage{
  @Consume('appPathStack') appPathStack: NavPathStack

  @State webData:WebData =new WebData(0,"")
  build() {
    NavDestination(){
      NodeContainer(getNWeb())
        .width('100%')
        .height('100%')
    }
    .onReady(()=>{
     this.webData= this.appPathStack.getParamByIndex(0) as WebData
    //  createNWeb(this.webData,this.getUIContext())
    })
    .title("动态加载网页")

  }

}