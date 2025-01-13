import { CustomTabBar } from '../components/CustomTabBar'
import { TAB_INFO } from '../model/TabBarClass'
import { TabBarClass } from '../model/TabBarClass'


@Entry
@Component
struct Index {
    @State message: string = 'Hello World';

    @State selectedIndex: number = 0;
    @State tabsInfo: TabBarClass[] = TAB_INFO;
    private controller: TabsController = new TabsController();

    build() {
        Column() {
            Tabs({
                index: this.selectedIndex,
                barPosition: BarPosition.End,
                controller: this.controller
            }) {
                // 将 this.selectedIndex 赋给 index
                TabContent() {
                    Text("首页")
                }
                .backgroundColor(Color.White)
                .height('100%')

                TabContent() {
                    //ProfilePage()
                    //HomePage()
                    Text("明细")
                }

                TabContent() {
                    //ProfilePage()
                    Text("我的")
                }
            }
            .vertical(false)    // 页签水平排列（禁止竖直）
            .scrollable(true)   // 页签可滚动
            .layoutWeight(1)
            .backgroundColor('#ffdbd9d9')
            .barHeight(3)       // 控制页签栏上面轮廓的宽度
            .onChange((index: number) => {
                this.selectedIndex = index;
            })

            CustomTabBar({ selectedIndex: this.selectedIndex, tabsInfo: this.tabsInfo })
        }
        .height('100%')
        .width('100%')
    }
}