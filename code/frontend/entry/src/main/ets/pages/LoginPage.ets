import router from '@ohos.router';

@Entry
@Component
struct LauncherPage {
    private countDownSeconds : number = 3  //登录界面持续时间，后面删除
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
        RelativeContainer() {
            Text("这里实现登录注册界面，通过则进入app主页，否则保持登录界面。\n")
              .id('Launch')
              .fontSize(20)
              .alignRules({
                center: { anchor: '__container__', align: VerticalAlign.Center },
                middle: { anchor: '__container__', align: HorizontalAlign.Center }
              })
            // Text(this.message)
            //   .id('Launch')
            //   .fontSize(50)
            //   .fontWeight(FontWeight.Bold)
            //   .alignRules({
            //     center: { anchor: '__container__', align: VerticalAlign.Center },
            //     middle: { anchor: '__container__', align: HorizontalAlign.Center }
            //   })
        }
        .height('100%')
        .width('100%')
    }
}