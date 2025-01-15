import { TAB_INFO } from '../model/TabBarClass'
import { TabBarClass } from '../model/TabBarClass'
import {BillInfo,TempBills} from '../model/BillInfo'

import { CustomTabBar } from '../components/CustomTabBar'
import {BillPage} from '../components/BillPage'

@Entry
@Component
struct Index {
    @State message: string = 'Hello World';

    @State selectedIndex: number = 0;
    @State tabsInfo: TabBarClass[] = TAB_INFO;

    @State billInfo: BillInfo[] = [];
    private controller: TabsController = new TabsController();

    onPageHide(): void {
    }
    aboutToAppear(): void {
        this.billInfo = TempBills;

    }
    onPageShow(): void {
        //这里调用函数获取数据吗?还是在登录界面实现
        //应该是的，这里每次调用接口来获取更新后的数据
        this.billInfo = TempBills;
    }

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
                    BillPage({
                        billInfo:$billInfo
                    })
                        .height('100%')
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