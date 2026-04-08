# better_sw_drag_for_moonlight

[English](./README.md) | [简体中文](./README.zh-CN.md)

用于改善 Moonlight 串流环境下 SolidWorks 拖动体验的 AutoHotkey 脚本集合。

## 项目简介

这个仓库主要解决一个很具体的远程 CAD 使用问题：

- 通过 Moonlight 串流时，中键拖动不一定容易稳定触发
- SolidWorks 会对 `Alt`、`Shift`、`Ctrl` 等修饰键做不同解释
- 右键笔势、右键菜单和视角拖动之间容易互相冲突

这个项目提供了一组小型脚本，用来调试并优化这些交互行为。

## 包含内容

- [`sw.ahk`](./sw.ahk)：主脚本，只在 SolidWorks 中生效
- [`moonlight-rbutton-probe.ahk`](./moonlight-rbutton-probe.ahk)：用于记录串流环境下右键和修饰键输入的诊断脚本
- [`CHANGELOG.md`](./CHANGELOG.md)：版本和变更记录
- [`LICENSE`](./LICENSE)：项目许可证

## 当前行为

当前版本的 `sw.ahk` 设计目标是只服务于 SolidWorks：

- 仅当 `SLDWORKS.exe` 位于前台时才启用
- 按住右键并按 `Q`，会把动作转换为中键拖动
- 当前逻辑是基于真实 Moonlight 输入日志逐步调出来的

这个仓库强调“实用可用”，不是做一个通用热键框架，而是记录在真实环境下验证过的方案。

## 环境要求

- Windows
- SolidWorks
- AutoHotkey v2
- Moonlight 串流工作流

## 快速使用

1. 安装 AutoHotkey v2。
2. 运行 [`sw.ahk`](./sw.ahk)。
3. 打开 SolidWorks。
4. 按住右键，再按 `Q`，触发中键拖动行为。

## 输入调试

如果串流输入行为不稳定，可以使用 [`moonlight-rbutton-probe.ahk`](./moonlight-rbutton-probe.ahk)。

推荐流程：

1. 运行探针脚本。
2. 在 Moonlight + SolidWorks 环境里复现问题。
3. 查看生成的日志文件，确认到底哪些鼠标和键盘事件真正到达了 Windows 主机。

## 设计说明

- 这些脚本是基于真实 Moonlight 输入轨迹调试出来的，不是假设本地输入行为一定成立。
- 当 `Alt` 等修饰键会干扰 SolidWorks 视角控制时，会优先避开它们。
- 某些版本的实现会优先保证远程可用性，而不是完全复刻本地鼠标行为。

## 项目定位

这是一个针对单一问题的实用型仓库，不是一个通用的输入重映射框架。

目标很明确：

- 让一个具体的远程 SolidWorks 工作流更顺手
- 保持脚本足够小，方便继续手工修改
- 保留足够的日志和说明，便于以后继续调试

## 许可证

本项目采用 MIT License。详见 [`LICENSE`](./LICENSE)。
