import { CommonConstants } from '../common/CommonConstants';
import { TabBarClass } from '../model/TabBarClass'

/*

* 这是一个自定义的TabBar组件(CustomTabBar) [未使用]
* 功能是图片下面带文字，当页签被选中时，图片变黑
 */

@Component
export struct CustomTabBar {
    // 父组件传递的参数
    @Link selectedIndex: number;
    tabsInfo: TabBarClass[] = [];
    @State iconOffset: number = 0;
    @Link currentBreakpoint: string;

    build() {
        Flex({ direction: (this.currentBreakpoint == 'lg')?FlexDirection.Column:FlexDirection.Row, justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
            ForEach(this.tabsInfo, (item: TabBarClass, tabBarIndex: number) => {
                this.tabItemBuilder(tabBarIndex)
            }, (item: TabBarClass) => JSON.stringify(item))
        }
        // .padding({ bottom: px2vp(this.avoidAreaBottomToModule) })
        .height($r('app.float.custom_tab_height_size'))
    }

    @Builder
    tabItemBuilder(tabBarIndex: number) {
        Column() {
            Stack() {
                // 判断tab的下标是否为2

                Column() {
                    // 通过被选中的tabBar下标值和tabBar的默认下标值来改变图片显示
                    Image(this.selectedIndex === tabBarIndex ? this.tabsInfo[tabBarIndex].selectedIcon :
                    this.tabsInfo[tabBarIndex].defaultIcon)//
                        .interpolation(ImageInterpolation.High)
                        .size({
                            width: $r('app.float.custom_tab_image_size'),
                            height: $r('app.float.custom_tab_image_size')
                        }) //
                    .offset({
                        y: (this.selectedIndex === tabBarIndex &&
                            this.selectedIndex !== CommonConstants.COMMUNITY_TAB_BAR_INDEX) ?
                        this.iconOffset : 0
                    })//
                    .animation({
                        duration: CommonConstants.CUSTOM_ANIMATION_DURATION,
                        curve: Curve.Ease,
                        iterations: CommonConstants.CUSTOM_ANIMATION_ITERATIONS,
                        playMode: PlayMode.Normal
                    })
                    Text(this.tabsInfo[tabBarIndex].text)
                        .fontSize($r('app.float.custom_tab_text_font_size'))
                        .fontWeight(FontWeight.Normal)
                        .fontColor(this.tabsInfo[tabBarIndex].defaultFontColor)

                }
                .width($r('app.float.custom_tab_image_container_size'))
                .height($r('app.float.custom_tab_image_container_size'))
                .justifyContent(FlexAlign.Center)



            }
            .width($r('app.float.custom_tab_height_size'))
            .onClick(() => {
                // 更新被选中的tabBar下标
                this.selectedIndex = tabBarIndex;
                // 控制tabBar的Image图片向上偏移
                this.iconOffset = -3;
            })
        }



    }




}