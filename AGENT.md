# 学术幻灯片模板：使用说明与制作规范

本文件是模板的完整制作规范与接口说明；仓库首页仅提供快速开始。制作或修改报告前先阅读本文件。模板可整文件夹复制、移动和交付；使用方法与内容规范均在此说明，不需要其他工程目录、已有演示文稿、特定论文、先前对话或外部说明文件。

## 1. 文件与运行环境

模板文件夹包含：

| 文件 | 用途 |
|---|---|
| `AGENT.md` | 使用方法、学术分享的组织原则、视觉规范与交付检查 |
| `lib.typ` | 主题、页面布局、图文组件与定位接口 |
| `starter.typ` | 14 页章节式起稿，可按内容与时长删减 |
| `build/starter.pdf` | 起稿的编译预览，运行构建后生成，不进入版本控制 |
| `examples/demo.typ` | 两页通用展示示例 |
| `docs/images/` | README 使用的两张示例图 |
| `README.md` | 简短的仓库首页 |
| `LICENSE` | MIT 许可证 |
| `tests/` | 脚本的行为与独立使用检查 |
| `new-talk.py` | 生成独立的新报告文件夹 |
| `build.py` | 检查字体、编译或持续预览 |

运行需要 Typst 0.11.1 或更新版本、Python 3.9 或更新版本，以及本地可用的 Gill Sans MT 字体。构建脚本只使用 Python 标准库；模板不导入在线 Typst 包，不访问网络，也不需要其他工程文件。字体属于运行环境，未随模板分发。

macOS 上构建脚本会自动查找已安装 Microsoft Office 附带的字体；也可以将有许可的字体放在工程根目录的 `fonts/` 中，或用 `--font-path` 指定目录。`Gill Sans` 与 `Gill Sans MT` 是不同字体，缺少后者时脚本明确报错，不静默替换。

## 2. 两种开始方式

### 直接编辑模板

进入本文件所在文件夹，编辑 `starter.typ`，运行：

```sh
python3 build.py
```

输出为 `build/starter.pdf`。`build/`、本地字体和缓存均由 `.gitignore` 排除。持续预览：

```sh
python3 build.py --watch
```

### 创建独立新报告

在本文件所在文件夹运行：

```sh
python3 new-talk.py ../my-talk --title "Your research title" --authors "Your names"
cd ../my-talk
python3 build.py
```

`../my-talk` 是新报告的输出位置，必须尚不存在；可以换成任意新路径。新报告建立后即可脱离模板的原始位置独立使用，目录结构为：

```text
my-talk/
  AGENT.md
  main.typ
  build.py
  .gitignore
  template/
    lib.typ
    LICENSE
  assets/
  build/              # 构建后生成
    main.pdf
```

编辑 `main.typ`，将自己的图表放入 `assets/`。`python3 build.py` 输出 `build/main.pdf`。生成器也支持 `--subtitle`、`--affiliation` 和 `--system`；`--system` 用于填写系统总览页的正式名称。

字体目录可显式指定：

```sh
python3 build.py --font-path /path/to/fonts
```

也可以使用环境变量 `SLIDES_FONT_PATH`；多个目录以操作系统的路径分隔符分隔。指定其他源文件或输出文件：

```sh
python3 build.py main.typ --output talk.pdf
```

运行这些命令不需要启动演示软件。构建文件默认进入工程根目录的 `build/`；`--output` 可以覆盖位置。新建器拒绝覆盖已存在的目录，填写内容按 Typst 字符串转义。

预览仓库自带的两页展示示例：

```sh
python3 build.py examples/demo.typ --root .
```

输出为 `build/demo.pdf`。图文规范仍以本文件和 `lib.typ` 为准。模板代码与仓库文档使用 MIT 许可证；生成项目保留 `template/LICENSE` 中的模板版权声明，用户自行提供的论文内容、图片及字体不因模板而获得额外授权。

维护仓库时使用 `python3 -m unittest discover -s tests -v` 检查脚本行为。在已有 Typst 和 Gill Sans MT 的机器上，设置 `SLIDES_RUN_INTEGRATION=1` 可同时验证新建项目在移除原模板目录后仍能独立编译。GitHub Actions 执行无需字体的脚本检查，不分发或下载商业字体。

## 3. 从论文到分享：先设计论证

### 先确定中心问题

先读摘要、引言与结论，再读关键方法和实验。记录听众背景、报告时长、研究问题、主要贡献与适用边界。只选择在现有时间内能够充分论证的一条主线；不要按论文章节机械压缩，也不要让方法细节抢在动机之前出现。大标题统一采用下述固定章节命名，不能自行改成结论句或提问句。

推荐顺序：

> 研究场景 → 可观察的问题 → 现有方法的缺口 → 核心洞察 → 方法 → 验证 → 收益与代价 → 结论。

在备稿时为每页写一句“这页要让听众相信什么”，把它放在正文或页底结论中。大标题标明章节位置，连读页底结论应形成完整论证。若某页可以任意移到别处而不影响理解，重新检查它的任务和位置。

### 用证据建立需求

把抽象问题落到可观察现象。每组动机完成“看到什么 → 为什么重要 → 因此方法需要满足什么”的闭环。必要时先用一页概括两三个需求，再逐项展示证据。

明确区分三件事：优化目标、必须满足的约束、最终采取的规则。不要把一个相关指标当成目标本身，也不要让听众猜测不同模块为何存在。

### 先给地图，再解释方法

先展示系统、流程或概念总览，建立输入、输出与模块关系，再逐步解释局部机制。重复总览图时保持空间位置一致，只高亮当前部分，每次补充一个新的解释。

方法页应回答：输入是什么、输出是什么、为什么需要这一步、后续如何使用它。公式只保留解释核心机制所必需的部分；先定义符号，再给关系，最后解释物理或统计含义。较长推导、实现细节与次要变体放入附录或讲稿。

### 让验证逐层回答问题

实验或分析可以按以下问题组织，并根据研究类型删减：

1. 整体结论是否成立？给主要比较与核心指标。
2. 结论是否稳定？给时间变化、数据子集、重复实验或敏感性分析。
3. 为什么成立？通过消融、对照、机制证据或误差分析检验解释。
4. 适用范围在哪里？说明规模、条件、数据限制与外推边界。
5. 收益伴随什么代价？同时报告重要的失败案例和权衡。

消融或对照页面明确标注不变项、变化项、比较方向、指标与设置。只有一张大表而没有比较逻辑，不能充分解释机制贡献。

## 4. 每页如何写

一个页面承担一个主要推理任务。多个子图可以共同支持一个比较，但必须告诉听众先看哪里、看什么，再解释它与主张的关系。

高频结构：固定章节式大标题 → 主要证据 → 两三个解读点 → 页底单句结论。大标题使用名词短语，表明本页属于哪项需求、哪项设计或哪类评估；具体发现、问题和判断放在正文与页底结论中。正文用来引导观看，不代替口头讲解。

图表应标清坐标、单位、图例、比较对象、条件与来源。突出当前主讲的数据或区域；保留足以检验结论的上下文，不为了美观裁掉关键证据。使用表格时让听众清楚需要比较哪些行列。

每张图都要被讲到。未计划解释的证据移入附录。引用贴近对应主张或图表，并按需要补充完整参考文献。

讲稿使用“承接 → 读图 → 含义 → 限定 → 转场”的顺序。将长定义、补充数字和问答备查留在讲稿，屏幕只保留理解当前推理所需的信息。

总结页回答最初的问题，概括问题洞察、核心方法、主要证据和边界，适合在问答时停留。联系方式或论文链接仅使用实际提供的信息。

### 大标题的固定规范（必须遵守）

这是模板的结构约束，不是可自由选择的标题风格。封面使用论文名；所有内容页使用 `section-slide` 或由 `section-title` 生成的大标题。不得将标题改写为发现句、主张句、宣传语或问题句。用户明确要求另一种标题风格时才改变。

| 页面角色 | 固定大标题格式 | 可填写部分 |
|---|---|---|
| 场景与背景 | `Background: <research setting>` | 研究场景的名词短语 |
| 需求总览 | `Workload characterization` | 标题固定，需求列表写正文 |
| 单项需求 | `Requirement 1: <requirement>` | 连续编号及需求名词短语 |
| 现有方法与困难 | `Existing approaches and challenges` | 标题固定 |
| 系统总览 | `<System name>: System overview` | 系统正式名称 |
| 核心设计 | `Design 1: <mechanism>` | 连续编号及机制名词短语 |
| 实验配置 | `Experimental setup` | 标题固定 |
| 端到端评估 | `End-to-End: <evaluation topic>` | 评估主题，不写实验结论 |
| 消融 | `Ablation: <mechanism or factor>` | 被消融的机制或变量 |
| 其他验证 | `Evaluation: <validation topic>` | 验证主题 |
| 生产部署 | `Production deployment at scale` | 标题固定，只有实际生产证据才使用 |
| 讨论 | `Discussion: <topic>` | 讨论主题 |
| 收束 | `Contributions and takeaways` | 标题固定 |
| 文献 | `References` | 标题固定；附录文献用 `Appendix: References` |
| 附录 | `Appendix: <topic>` | 补充材料主题 |

顺序固定为：背景/特征与需求 → 现有方法与困难 → 系统总览 → 编号设计 → 实验配置 → 评估与消融 → 总结。多个需求或设计各用一页，也可在短报告中合并为较少项；编号连续且正文保持对应。不能为了压缩时长删掉实验配置，或把一张结果图仅改名成 Design/Experimental setup：页面内容必须符合其章节职责。文献与补充材料可放在总结后的附录，问答停留在总结页。

这里固定的是章节名称和命名模式，不强制每篇论文恰好有三项需求或两项设计。根据实际贡献删减整个不适用模块，不能凭空补造需求、设计、生产部署或实验。页底结论仍要清楚说明该页证据的含义。

实现入口在 `lib.typ`：`section-title` 集中写死固定标题与前缀，检查页面类型及所需编号/名称；`section-slide` 用它生成标题。普通 `slide` 是底层布局兼容接口，后续 agent 不应直接传入自由撰写的大标题。双栏/图文组件的标题也必须通过 `section-title` 生成。

## 5. 数字与证据口径

建立内部 claim–evidence 表，每项主张记录来源位置、图表、比较对象、条件与限制。不要把这个表全部塞进主讲页面。

报告数字时保留“指标＋比较对象＋设置＋聚合方式”：

- 区分百分比与百分点、绝对变化与相对变化。
- 区分均值、中位数、尾部分位数；分组统计不能改写成每个样本都满足。
- 区分单个样本的指标与时间窗口聚合指标。
- 区分资源配置、实际使用量、时间消耗与利用率。
- 归一化轴不能直接按原始物理单位读取。
- 相关性不能直接改写为因果效应；非随机前后比较必须保留设计限制。
- 某个设置下的较好参数值不能宣称为普适最优。
- 改善一个指标不能概括为所有维度均有提升；重要代价一起报告。
- 示意图与实测数据分开标注；不能从示意图推导精确量化结论。
- 正文、图例、术语、版本号与引用编号保持一致；最终数字回到论文或原始结果核查。

## 6. 视觉规范

保持固定主题，除非用户明确要求改变：

| 项目 | 规范 |
|---|---|
| 画布 | 960×540pt，16:9；坐标数值单位为 PDF pt |
| 内容边界 | 左 x=60，右 x=900，内容宽 840pt |
| 字体 | Gill Sans MT；数学公式使用 Typst 的数学排版 |
| 背景与正文 | 白底、黑色正文 |
| 强调色 | `#2E7BC4`，用于小标题与结论条 |
| 页标题 | 默认 48pt；较长标题用 42/40pt，尽量保持一行 |
| 小标题 / 正文 | 约 22pt / 20pt |
| 图注 / 页码 | 约 14pt / 12pt |
| 内容页页码基线 | y=530.88，位于底部结论条下方 |
| 标题分隔线 | y=96，高 1.5pt，黑色 |
| 内容顶部 | 约 y=120 |
| 图左文右 | 常用图区 x=60、宽 510pt；右栏从 x=592.5 开始 |
| 结论条 | 常用 y=489、高 28.5pt；文字过长时改用普通结论文本 |
| 封面 | 蓝带 y=99、高 132pt；两行标题为 36pt |

正文左对齐，按字号、字重与留白建立层级，不添加无信息作用的装饰。图表的颜色应服务证据区分。必要脚注和引用始终在画布可见区域内，并避开页码。

优先使用 SVG 或清晰的源图；检查投影尺寸下的坐标与图例可读性。不要将整页截图作为可编辑幻灯片。图像组件默认适配给定矩形，选取与素材比例一致的宽高，避免拉伸失真。

长内容先改写措辞、重组论证或拆页，再考虑缩小字号。控制正文约 20pt，避免为了塞内容不断压缩。

## 7. Typst 接口与最小示例

直接编辑模板时导入 `"lib.typ"`；生成的新报告导入 `"template/lib.typ"`。页面之间显式写 `#pagebreak()`。

```typ
#import "template/lib.typ": *
#show: deck

#title-slide(
  [Your research title],
  [A short subtitle],
  [Author names],
  affiliation: [Research group],
)
#pagebreak()

#section-slide("requirement", index: 1, topic: [Requirement topic], title-size: 42)[
  #heading(60, 123, 840, [The visible observation])
  #textbox(60, 170, 840, [Describe the evidence and its interpretation.])
  #takeaway([One sentence connecting the evidence to the main claim.])
]
```

常用接口：

| 接口 | 用途 |
|---|---|
| `#show: deck` | 纸张、字体与段落默认值 |
| `title-slide(title, subtitle, authors, ...)` | 封面，可传 `affiliation`、`note` |
| `section-slide(kind, ...)[...]` | 标准内容页；标题由固定章节规范生成，可传 `topic`、`index`、`system`、`claim`、`title-size` |
| `section-title(kind, ...)` | 生成同一套固定标题，供双栏、图文等组件使用 |
| `slide(title)[...]` | 底层布局兼容接口；正常写作使用上述标准章节接口 |
| `two-column-slide(title, lhs, rhs, ...)` | 双栏方法或比较 |
| `evidence-slide(title, source, notes, ...)` | 图左文右；可传 `source-note`、`claim` |
| `results-slide(title, source, metrics, ...)` | 大图加三项数值摘要；metrics 是三个 `(标题, 数值, 说明)` 元组 |
| `heading(x, y, w, body)` | 蓝色加粗小标题 |
| `textbox(x, y, w, body)` | 自然换行正文；支持 `size`、`weight`、`fill`、`leading`、`align-to` |
| `bullets(x, y, w, items)` | 项目列表；items 是内容元组，支持 `size`、`gap` |
| `caption(x, y, w, body)` | 灰色图注 |
| `takeaway(body)` | 蓝底结论；`blue: false` 改为普通黑色结论 |
| `figure(x, y, w, h, source)` | 图片定位；可传 `crop: (左, 上, 右, 下)`，四值为裁剪比例 |
| `panel(x, y, w, h, ...)` | 矩形区域；可传 `fill`、`stroke`、`radius` |
| `at(x, y, body)` | 内容定位 |
| `baseline(x, y, body)` | 精确指定文字基线 |

`traced-line` 是可选低层接口，用于有逐字符测量值的排字：调用者直接提供 `(text: 原文字串, offsets: 字符横向偏移元组)`。文字改变时退回正常排字。普通报告无需使用它，也无需任何测量文件。

图片在模板函数中按库文件的位置解析，因此推荐使用相对**工程根目录**的路径，例如 `/assets/result.svg`；此处 `/` 由构建脚本的 Typst `--root` 解释，不是操作系统磁盘根目录。

以下示例假定新报告已有自己的 `assets/result.svg`：

```typ
#evidence-slide(
  section-title("end-to-end", topic: [Performance comparison]),
  "/assets/result.svg",
  [
    #text(fill: style.blue, weight: "bold")[Observation]
    #v(10pt)
    State the measured comparison and the condition.
  ],
  source-note: [Author et al., paper section and figure],
  claim: [Explain why this result matters.],
  title-size: 42,
)
```

图表由当前报告自行提供；空白起稿无需任何外部图表就能编译。

## 8. 完成与交付检查

1. 大标题全部符合固定章节命名；需求与设计编号连续。中心问题明确，正文及页底结论能串起完整论证。
2. 需求有证据，方法回应需求，验证检验对应主张。
3. 数字、单位、比较对象、实验条件、聚合方式和限制准确。
4. 术语与名称一致，图表来源可追溯，没有旧版本页码或讲稿安排。
5. 逐页检查字体、换行、图表比例、重叠、裁切、页码与引用。
6. 以实际页面重算时长，预先确定可压缩内容，保留问题、关键证据与结论。
7. 重新编译最新源稿，再查看全部页面，不只依赖编译成功。
8. 将待交付文件夹复制到独立位置，从该位置编译，确认导入和素材没有指向原工程。
9. 交付源稿、当前报告的素材和需要的输出文件；本文件作为完整说明一并保留。
