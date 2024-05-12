#import "@preview/tidy:0.2.0"
#import "shogi-board.typ": shogi-board-from-sfen

= 概要

SFEN形式の入力から将棋盤を簡単に作成するtypstのモジュールです。

= 例

```typ
#shogi-board-from-sfen("lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b -")
```
#shogi-board-from-sfen("lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b -")

```typ
#shogi-board-from-sfen("4k4/9/4P4/9/9/9/9/9/9 b G")
```
#shogi-board-from-sfen("4k4/9/4P4/9/9/9/9/9/9 b G")

= API Reference

#let docs = tidy.parse-module(read("shogi-board.typ"))
#tidy.show-module(docs)