# DOS C 编译环境

已安装 Open Watcom C/C++ 1.9 的 DOS C 组件到课程目录 `TOOLS/WATCOM`，使用现有 DOSBox Staging。
本次只新增课程文件夹内的工具、配置和编译脚本，未修改 Mac 全局编译环境。

## 启动

在 Mac 终端执行：

```sh
cd "/Users/tranquil618/codespace/大三/上/汇编语言/作业/作业2"
dosbox-staging --noprimaryconf --nolocalconf --conf DOSC.CONF
```

新窗口应显示 `D:\>`。C: 指向课程根目录，D: 指向本作业目录。
配置已设置 WATCOM、INCLUDE、PATH；MASM、LINK、DEBUG 也仍可调用。

## 编译和运行

在 DOSBox 中输入：

```bat
CBUILD
SUMC
SUMNC
```

CBUILD 会编译两份 C 源码，任何一步失败就停止。
SUMC.EXE 对应 sum.c；SUMNC.EXE 对应 sumn.c，后者需输入 1～100 的整数并按回车。
名称与汇编版 SUM.EXE、SUMN.EXE 分开，目标文件也分开，避免覆盖。
源代码的算法未改动，仅为两份 C 文件补齐末尾换行，消除旧编译器的 W138 警告。

手动编译命令：

```bat
wcl -bt=dos -0 -ms -od -d2 -fo=sumc.obj -fe=sumc.exe -fm=sumc.map sum.c
wcl -bt=dos -0 -ms -od -d2 -fo=sumnc.obj -fe=sumnc.exe -fm=sumnc.map sumn.c
```

- wcl：16 位 C 编译、链接工具；不要换成 wcl386。
- -bt=dos：目标为 DOS。
- -0：生成 8086/8088 指令。
- -ms：小内存模型。
- -od：禁用优化，便于学习和反汇编对照。
- -d2：保留调试信息。
- -fo/-fe/-fm：指定目标文件、可执行文件和链接映射文件。

## 反汇编

已实际执行以下命令，生成 SUMC.DIS、SUMNC.DIS：

```bat
wdis SUMC.OBJ -s=SUM.C -l=SUMC.DIS
wdis SUMNC.OBJ -s=SUMN.C -l=SUMNC.DIS
```

WDIS 对实际编译生成的 OBJ 目标文件进行反汇编，并插入对应 C 源码。
它不是 EXE 加载后的内存反汇编；其中调用地址可能尚未完成链接修正。
这些文件是原始工具输出，目前尚未添加中文讲解注释；后续学习直接从 main_ 开始阅读。
若需要查看完整 EXE 的实际指令，可以用 DEBUG SUMC.EXE 或 DEBUG SUMNC.EXE，结合 MAP 定位 main_。
EXE 入口通常是 C 运行库启动代码，不是 main 本身。

## 本次实际验证

已在 DOSBox 中使用上述 DOS 工具编译、链接和运行，不是使用 Mac ARM64 产物替代。

| 程序/输入 | 输出 |
| --- | --- |
| SUMC | 5050 |
| SUMNC，输入 1 | 1 |
| SUMNC，输入 5 | 15 |
| SUMNC，输入 100 | 5050 |
| SUMNC，输入 0、101 | 范围错误提示 |
| SUMNC，输入 abc | Invalid input! |

编译日志、输入文件和实际输出保存在 CHECK 内。scanf 的输入语义保持原样，例如 12abc 仍会接受数字前缀 12。

## 官方资料

- [Open Watcom 1.9 官方发布页](https://github.com/open-watcom/open-watcom-1.9/releases/tag/ow1.9)
- [Open Watcom 1.9 工具手册](https://open-watcom.github.io/open-watcom-1.9/tools.html)
- 安装组件来源和许可见课程目录 TOOLS/WATCOM。
