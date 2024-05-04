#let shogi-board(..ranks, sente: "", gote: "") = {
  let pieces = (
    K: "王",
    R: "飛",
    B: "角",
    G: "金",
    S: "銀",
    N: "桂",
    L: "香",
    P: "歩",
    k: rotate(180deg, "玉"),
    r: rotate(180deg, "飛"),
    b: rotate(180deg, "角"),
    g: rotate(180deg, "金"),
    s: rotate(180deg, "銀"),
    n: rotate(180deg, "桂"),
    l: rotate(180deg, "香"),
    p: rotate(180deg, "歩"),
    " ": "",
  )

  grid(
    columns: (auto, auto, auto),
    stack(dir: ttb, spacing: 0.5em, "⛊", ..gote.clusters().map(i => pieces.at(i))),
    pad(x: 1em,
    grid(
      columns: (1.5em,) * 10,
      rows: (1.5em,) * 10,
      align: center + horizon,
      ..(range(10)
          .map(i => grid.hline(y: i + 1, start: 0, end: 9))),
      ..(range(10)
          .map(i => grid.vline(x: i, start: 1, end: 10))),
      ..(range(9)
          .rev()
          .map(i => text(0.8em, str(i + 1)))),
      ..(" 一二三四五六七八九".clusters()
          .enumerate()
          .map(i => grid.cell(text(0.6em, i.at(1)), x: 9, y: i.at(0)))),
      ..for rank in ranks.pos() {
        rank.clusters().map(i => pieces.at(i))
      }
    ),
    ),
    stack(dir: ttb, spacing: 0.5em, "☗", ..sente.clusters().map(i => pieces.at(i))),
  )
}

#shogi-board(
  "lnsgkgsnl",
  " r     b ",
  "ppppppppp",
  "         ",
  "         ",
  "         ",
  "PPPPPPPPP",
  " B     R ",
  "NLSGKGSLN",
  sente: "PGS",
  gote: "pgs",
)

// TODO: USI(Universal Shogi Interface)プロトコル
// http://shogidokoro.starfree.jp/usi.html