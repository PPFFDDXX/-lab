import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import Router from '@system.router';

@Component
export struct ProfilePage{
  @State in_dark_mode:boolean=false
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogDemo({
      cancel: () => {
        this.onCancel()
      },
      confirm: () => {
        this.onAccept()
      }
    })
  })
  onCancel() {
    console.info('Callback when the first button is clicked')
  }

  onAccept() {
    console.info('Callback when the second button is clicked')
  }

  build() {
    Stack(){
      Column(){
        Image(/*this.token?this.userInfo.avatarUrl:*/$r('app.media.user_avatar'))
          .width(100)
          .height(100)
          .borderRadius(50)
          .margin({top:120})
        /*
        .onClick(()=>{
          router.pushUrl({url:'pages/LoginPage'})
        })
        */
        Text(/*this.token?this.userInfo.nickname:'暂未登录'*/"abc")
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .margin({top:20})
        /*
        if (!this.token) {
          Text('请点击头像登录')
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.Black)
            .margin({ top: 4 })
        }
        */
      }
      .width('100%')
      .height('50%')
      .backgroundColor('#9595ca')
      .backgroundImage(/*this.token?this.userInfo.avatarUrl:*/$r('app.media.user_avatar_b'))
      .backgroundImageSize({ height: '100%', width: '100%' })
      .backgroundBlurStyle(BlurStyle.Regular)

      Column({space:10}){
        this.colorModeItemBuilder($r('app.media.ic_dark_mode'),'浅色模式','深色模式')

        Divider()
        this.mineItemBuilder($r('app.media.ic_mine_update'),'检查更新','已是最新')
        Divider()
        this.mineItemBuilder($r('app.media.ic_mine_about'), '关于', '没有关于')
        Blank()
        if(1/*this.token*/){
          Button('退出登录')
            .width('100%')
            .fontSize(18)
            .backgroundColor(Color.Gray)
            .fontColor(Color.White)
            .onClick(() => {
              if (this.dialogController != null) {
                this.dialogController.open()
              }
            })
        }
      }
      .width('100%')
      .height('60%')
      .offset({ y: '40%' })
      .borderRadius({ topLeft: 50, topRight: 50 })
      .backgroundColor(Color.White)
      .padding(30)
    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.Top)
  }
  @Builder
  colorModeItemBuilder(icon:Resource,title1:string,title2:string){
    Row({space:10}){
      Image(icon)
        .width(24)
        .height(24)
      Text(this.in_dark_mode==true?title1:title2)
        .fontSize(16)
        .height(24)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.Black)
      Blank()
      Image($r('app.media.ic_arrow_right'))
        .width(24)
        .height(24)
    }
    .width('100%')
    .height(40)
    .onClick(()=>{
      if(this.in_dark_mode){
        this.in_dark_mode=false
      }
      else{this.in_dark_mode=true}
    })
  }
  @Builder
  mineItemBuilder(icon:Resource,title:string,text:string){
    Row({space:10}){
      Image(icon)
        .width(24)
        .height(24)
      Text(title)
        .fontSize(16)
        .height(24)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.Black)
      Blank()
      Image($r('app.media.ic_arrow_right'))
        .width(24)
        .height(24)
    }
    .width('100%')
    .height(40)
    .onClick(()=>{
      promptAction.showToast({ message: text })
    })
  }

}
@CustomDialog
struct CustomDialogDemo {
  controller?: CustomDialogController
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }

  build() {
    Column({ space: 20 }) {
      Text('是否退出')
        .fontSize(20)
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close()
              this.cancel()
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        /*Divider().vertical(true).height(40).opacity(4).margin({ left: 0, right: 0 })*/
        Button('退出')
          .onClick(() => {
            if (this.controller != undefined) {
              router.replaceUrl({
                url: 'pages/LoginPage'
              })
              this.controller.close()
            }
          }).backgroundColor(Color.Red).fontColor(Color.White)
      }.margin({ bottom: 10 })
    }.borderRadius(10).padding({ top: 20 })
  }
}