/*
* 这是一个定义TabBar所需信息的类
* @param id: 页签id
* @param text: 页签的名称
* @param defaultIcon: 页签默认图标
* @param selectedIcon: 页签被选中图标
* @param defaultFontColor: 页签字体默认颜色
* @param selectedFontColor: 页签字体被选中颜色
*/


export class TabBarClass {
    id: number;
    text: string;
    defaultIcon: ResourceStr;
    selectedIcon: ResourceStr;
    defaultFontColor: ResourceColor;

    constructor(id: number,
        text: string,
        defaultIcon: ResourceStr,
        selectedIcon: ResourceStr,
        defaultFontColor: ResourceColor) {
        this.id = id;
        this.text = text;
        this.defaultIcon = defaultIcon;
        this.selectedIcon = selectedIcon;
        this.defaultFontColor = defaultFontColor;
    }
}


// 数据为临时的
export const TAB_INFO: TabBarClass[] = [
    new TabBarClass(0, "首页", $r("app.media.tab_home_default"), $r("app.media.tab_home_selected"),
        $r("app.color.tabBar_font")),
    new TabBarClass(1, "明细", $r("app.media.tab_find_default"), $r("app.media.tab_find_selected"),
        $r("app.color.tabBar_font")),
    new TabBarClass(2, "我的", $r("app.media.tab_profile_default"), $r("app.media.tab_profile_selected"),
        $r("app.color.tabBar_font"))
];
// 对于const修饰的变量，遵循大写+下划线命名规则