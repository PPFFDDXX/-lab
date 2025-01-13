import { TabBarClass } from '../model/TabBarClass'

/*

* 这是一个自定义的TabBar组件(CustomTabBar)
* 功能是图片下面带文字，当页签被选中时，图片变黑
 */

@Component
export struct CustomTabBar {
    // 父组件传递的参数
    @Link selectedIndex: number;
    tabsInfo: TabBarClass[] = [];

    build() {
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
            // 数据量比较少的情况下推荐使用ForEach，遇到数据量比较多的场景，如列表场景、瀑布流场景等，推荐使用LazyForEach(https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-rendering-control-lazyforeach-V5)
            ForEach(this.tabsInfo, (item: TabBarClass, tabBarIndex: number) => {
                // 单独一个TabBar组件
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
                    this.tabsInfo[tabBarIndex].defaultIcon)// TODO：知识点：使用interpolation属性对图片进行插值，使图片显示得更清晰
                        .interpolation(ImageInterpolation.High)
                        .size({
                            width: $r('app.float.custom_tab_image_size'),
                            height: $r('app.float.custom_tab_image_size')
                        }) // TODO：知识点：通过offset控制图片的纵向偏移。
                    // .offset({
                    //     y: (this.selectedIndex === tabBarIndex &&
                    //         this.selectedIndex !== CommonConstants.COMMUNITY_TAB_BAR_INDEX) ?
                    //     this.iconOffset : $r('app.integer.custom_tab_common_size_0')
                    // })// TODO：知识点：组件的某些通用属性变化时，可以通过属性动画animation实现过渡效果。本示例的动画效果是tabBar的图片向上偏移一小段距离
                    // .animation({
                    //     duration: CommonConstants.CUSTOM_ANIMATION_DURATION,
                    //     curve: Curve.Ease,
                    //     iterations: CommonConstants.CUSTOM_ANIMATION_ITERATIONS,
                    //     playMode: PlayMode.Normal
                    // })
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
                // 此处控制tabBar的Image图片向上偏移
            })
        }



    }




}