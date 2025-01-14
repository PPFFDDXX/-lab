import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct LauncherPage {
  @State account:string='';
  @State password:string='';
    private countDownSeconds : number = 300  //登录界面持续时间，后面删除；应改为密码账号正确才可进入
    private timeId: number = 0;
    onPageShow(): void {
        this.timeId = setInterval(() => {
            this.countDownSeconds--;
            if (this.countDownSeconds === 0) {
                clearInterval(this.timeId); // 关闭定时器
                router.replaceUrl({ url: 'pages/Index' });
            }
        }, 1000)
    }

    build() {
        // RelativeContainer() {
        //     Text("这里实现登录注册界面，正确则进入app主页，否则保持登录界面。\n")
        //       .id('Launch')
        //       .fontSize(20)
        //       .alignRules({
        //         center: { anchor: '__container__', align: VerticalAlign.Center },
        //         middle: { anchor: '__container__', align: HorizontalAlign.Center }
        //       })
        //     // Text(this.message)
        //     //   .id('Launch')
        //     //   .fontSize(50)
        //     //   .fontWeight(FontWeight.Bold)
        //     //   .alignRules({
        //     //     center: { anchor: '__container__', align: VerticalAlign.Center },
        //     //     middle: { anchor: '__container__', align: HorizontalAlign.Center }
        //     //   })
        // }
        // .height('100%')
        // .width('100%')
        Column() {
            Image($r('app.media.bird'))
                .width(80)
                .height(80)
                .borderRadius(50)
                .margin({ top:"120vp" })
            Text("欢迎使用")
                .fontColor(Color.Black)
                .fontSize(14)
                .margin({ top:"25vp",bottom:'10vp' })
            TextInput({placeholder:'请输入账号'})
                .margin({bottom:'10vp'})
                .width('320vp')
                .onChange((value:string)=>{
                    this.account=value;
                })
            TextInput({placeholder:'请输入密码'})
                .type(InputType.Password)
                .width('320vp')
                .onChange((value:string)=>{
                    this.password=value;
                })
                .margin({bottom:'20vp'})
            Button('登录').width('100%').type(ButtonType.Capsule)
                .margin({bottom:'15vp'})
                .width('150vp')
                .onClick(()=>{
                    this.login();
                })
            Text('注册账号').fontColor(Color.Blue).fontSize(14)
                .onClick(()=>{

                })
            LoadingProgress().width(50).height(50).color(Color.Blue)
            Blank()

        }.border({width:1})
        .width("100%")
        .height("100%")
        .alignItems(HorizontalAlign.Center)
        .justifyContent((FlexAlign.Center))
    }
    login(){
        //判断是否存在账号
        if(514==514){
            promptAction.showToast({
                message:this.account,
                duration:2000
            })
        }
        else{
            promptAction.showToast({
                message:"不存在的账号",
                duration:2000
            })
        }
        //判断密码是否正确
        if(114==114){
            promptAction.showToast({
                message:"登录成功",
                duration:2000
            })
        }
        else{
            promptAction.showToast({
                message:"密码错误",
                duration:2000
            })
        }

    }
}