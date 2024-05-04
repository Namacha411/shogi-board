// 参考: SFENの形式については以下を参照してください。
// http://shogidokoro.starfree.jp/usi.html

#let shogi-board(ranks, sente: (""), gote: ("")) = {
  // SFENの駒文字列では、成駒を表す文字が2文字で1つの駒を表す
  // #str.clusters()で分解するために便宜上アクセント記号を使っている。
  let pieces = (
    K: "王",
    R: "飛",
    B: "角",
    G: "金",
    S: "銀",
    N: "桂",
    L: "香",
    P: "歩",
    Ṙ: "龍",
    Ḃ: "馬",
    Ṡ: "全",
    Ṅ: "圭",
    Ḷ: "杏",
    Ṗ: "と",
    k: rotate(180deg, "玉"),
    r: rotate(180deg, "飛"),
    b: rotate(180deg, "角"),
    g: rotate(180deg, "金"),
    s: rotate(180deg, "銀"),
    n: rotate(180deg, "桂"),
    l: rotate(180deg, "香"),
    p: rotate(180deg, "歩"),
    ṙ: rotate(180deg, "龍"),
    ḃ: rotate(180deg, "馬"),
    ṡ: rotate(180deg, "全"),
    ṅ: rotate(180deg, "圭"),
    ḷ: rotate(180deg, "杏"),
    ṗ: rotate(180deg, "と"),
    " ": "",
  )

  grid(
    columns: (auto, auto, auto),
    stack(dir: ttb, spacing: 0.4em, "⛊",
    ..gote.map(i => pieces.at(i))),
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
        ..for rank in ranks {
          rank.clusters().map(i => pieces.at(i))
        }
      ),
    ),
    stack(dir: ttb, spacing: 0.5em, "☗", ..sente.map(i => pieces.at(i))),
  )
}

#let sfen-banmen-parser(sfen) = {
  let convert = (
    R: "Ṙ",
    B: "Ḃ",
    S: "Ṡ",
    N: "Ṅ",
    L: "Ḷ",
    P: "Ṗ",
    r: "ṙ",
    b: "ḃ",
    s: "ṡ",
    n: "ṅ",
    l: "ḷ",
    p: "ṗ",
  )
  let ranks = sfen.split("/").map(rank => {
    let result = ""
    let i = 0
    let rank = rank.replace(regex("\+[RBSNLPrbsnlp]"), dict => convert.at(dict.at("text").at(-1)))
    for c in rank.clusters() {
      if (c.contains(regex("\d"))) {
        result += " " * int(c)
      } else {
        result += c
      }
    }
    result
  })
  ranks
}

#let sfen-mochigoma-parser(sfen) = {
  let mochigoma = sfen.replace(regex("\d+[RBGSNLPrbgsnlp]"), dict => {
    let count = int(dict.at("text").slice(0, -1))
    let piece = dict.at("text").slice(-1)
    piece * count
  })
  let sente = mochigoma
    .clusters()
    .filter(c => c.match(regex("[RBGSNLP]")) != none)
  let gote = mochigoma
    .clusters()
    .filter(c => c.match(regex("[rbgsnlp]")) != none)
  (sente, gote)
}

#let sfen-kyokumen-parser(sfen) = {
  let (bannmen, teban, mochigoma) = sfen.split(" ")
  let ranks = sfen-banmen-parser(bannmen)
  let (sente, gote) = sfen-mochigoma-parser(mochigoma)
  arguments(ranks, sente: sente, gote: gote)
}

#let shogi-board-from-sfen(sfen) = {
  shogi-board(..sfen-kyokumen-parser(sfen))
}