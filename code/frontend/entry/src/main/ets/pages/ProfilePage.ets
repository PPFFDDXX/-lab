import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { pasteboard } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import Want from '@ohos.app.ability.Want';
import Router from '@system.router';
import { ap } from '../common/trans';

@Component
export struct ProfilePage{
  @State
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
        Image(/*this.token?this.userInfo.avatarUrl:*/$r('app.media.user_avatar')) //头像
          .width(100)
          .height(100)
          .borderRadius(50)
          .margin({top:120})
        /*
        .onClick(()=>{
          router.pushUrl({url:'pages/LoginPage'})
        })
        */
        Text((ap.account != null)?ap.account:"abc") //用户名
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .margin({top:20})
        /*    //可能的点击头像登录实现
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
      .backgroundImage(/*this.token?this.userInfo.avatarUrl:*/$r('app.media.user_avatar_b')) //背景图(和用户头像相同)
      .backgroundImageSize({ height: '100%', width: '100%' })
      .backgroundBlurStyle(BlurStyle.Regular)//模糊化

      Column({space:10}){ //个人中心几个可点击项目
        this.mineItemBuilder($r('app.media.ic_mine_team'),'开发团队','前端成员：xyf，wy，wzd，ysy\n后端成员：zbc，xqx，hxy')
        Divider()
        this.mineItemBuilder($r('app.media.ic_mine_update'),'检查更新','已是最新版本')
        Divider()
        this.dialogItemBuilder($r('app.media.ic_mine_github'),'github')
        Divider()
        this.mineItemBuilder($r('app.media.ic_mine_about'), '关于', 'V 1.14.514')
        Blank()
        if(1/*this.token*/){
          Button('退出登录')
            .width('100%')
            .fontSize(18)
            .backgroundColor(Color.Gray)
            .fontColor(Color.White)
            .onClick(() => {
              if (this.dialogController != null) {
                this.dialogController.open()//重复确认弹窗的弹出
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
  dialogItemBuilder(icon:Resource,title:string){ //用于可点击项目的构建
    Row({space:10}){
      Image(icon)
        .width(24)
        .height(24)
      Text(title)
        .fontSize(16)
        .height(24)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.Black)
      Blank() //下面内容右对齐
      Image($r('app.media.ic_arrow_right'))
        .width(24)
        .height(24)
    }
    .width('100%')
    .height(40)
    .onClick(()=>{
      let text:string='github.com/PPFFDDXX/Harmony-OS-lab'
      AlertDialog.show({
        title: 'Please star our repository',
        message: text,
        autoCancel: true,//点击外侧空间可关闭dialog
        cancel: () => { },
        alignment: DialogAlignment.Bottom,//dialog出现在页面底部
        offset: { dx: 0, dy: -20 },
        //按钮功能设置
        primaryButton: {
          value: "复制",
          action: () => {
            //将网址复制到剪贴板
            const pasteboardData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, 'https://github.com/PPFFDDXX/Harmony-OS-lab');
            const systemPasteboard = pasteboard.getSystemPasteboard();
            systemPasteboard.setData(pasteboardData);
            promptAction.showToast({
              message: "网址已复制"
            });
          }
        },
        secondaryButton: { //虚拟机无浏览器,跳转功能无法有具体表现(是照着官方文档写的,应该没问题,日志也输出了正确内容)
          value: "跳转",
          action: () => {
            try {
              let want:Want = {//利用Want方法进行跳转
                action: 'ohos.want.action.viewData',
                entities: ['entity.system.browsable'],
                uri: 'https://github.com/PPFFDDXX/Harmony-OS-lab'
              }
              let context = getContext(this) as common.UIAbilityContext;
              context.startAbility(want)
              console.info(`explicit start ability succeed`)
            } catch (error) {
              console.info(`explicit start ability failed with ${error.code}`)
            }
          }
        }
      });
    })
  }
  @Builder
  mineItemBuilder(icon:Resource,title:string,text:string){ //用于可点击项目的构建
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
struct CustomDialogDemo { // 用于退出登录重复确认弹窗的构建
  controller?: CustomDialogController
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }

  build() {
    Column({ space: 20 }) {
      Text('确定退出')
        .fontSize(20)
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close()
              this.cancel()
            }
          }).backgroundColor('#D3D3D3').fontColor(Color.Black).width(130)
        /*Divider().vertical(true).height(40).opacity(4).margin({ left: 0, right: 0 })*/
        Button('退出')
          .onClick(() => {
            //replace到LoginPage
            if (this.controller != undefined) {
              ap.account = null;
              router.replaceUrl({
                url: 'pages/LoginPage'
              })
              this.controller.close()
            }
          }).backgroundColor(Color.Red).fontColor(Color.White).width(130)
      }.margin({ bottom: 10 })
    }.borderRadius(10).padding({ top: 20 })
  }
}