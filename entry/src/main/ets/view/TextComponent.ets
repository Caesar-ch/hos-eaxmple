@Component
export struct TextComponent {
  @Prop msg1: number = 0
  @Prop msg2: number = 0
  @Prop msg3: number = 0

  build() {

    Column({ space: 20 }) {

      Text("onAppear时间：" + this.msg1)
        .fontSize(16)


      Text("开始播放时间：" + this.msg2)
        .fontSize(16)


      Text("起播耗时：" + this.msg3)
        .fontSize(16)

    }
    .width('100%')

  }
}