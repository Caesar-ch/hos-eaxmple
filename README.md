
# 简介
>为了解决页面、组件加载缓慢的问题，ArkUI框架提供了动态操作以实现组件预创建，并允许应用在运行时根据实际需要加载渲染相应的组件。动态操作包含动态创建组件（动态添加组件）、动态卸载组件（动态删除组件）等相关操作。动态创建组件指在非build生命周期中进行组件创建，即在build生命周期前提前创建组件。通过动态创建组件，开发者不但可以节省组件创建的时间，提升用户体验，还可以将独立的逻辑进行封装，开发者能更加灵活地管理组件，有助于应用模块化开发。动态卸载组件是对动态创建的组件进行卸载、删除。

# 原理
>利用组件预创建机制，可以利用动画执行过程空闲时间进行组件预创建和属性设置。在动画结束后，再进行属性和布局的更新，节省了组件创建的时间，从而加快了页面渲染

# 要素
- [NodeContainer](https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-basic-components-nodecontainer-V5)
>自定义占位容器组件，主要是用于显示自定义节点以及自定义节点树的显示和复用,相当于Stack组件，仅具备组件的通用属性
- [NodeController](https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/js-apis-arkui-nodecontroller-V5)
>通过makeNode回调返回一个FrameNode节点树的根节点。将[FrameNode](https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/js-apis-arkui-framenode-V5)节点树挂载到对应的NodeContainer下。同时提供了aboutToAppear、aboutToDisappear、aboutToResize、onTouchEvent、rebuild五个回调方法用于监听对应的NodeContainer的状态