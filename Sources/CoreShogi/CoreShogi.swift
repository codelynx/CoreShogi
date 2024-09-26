//
//	CoreShogi.swift
//	CoreShogi
//
//	Created by Kaz Yoshikawa on 12/4/21.
//

import Foundation

func unused<T>(_ value: T) {
	// No operation to suppress warning for unused values
}

enum 筋型 : Int8, Equatable, CaseIterable, CustomStringConvertible {
//	case １, ２, ３, ４, ５, ６, ７, ８, ９
	case ９, ８, ７, ６, ５, ４, ３, ２, １
	static let 記号筋表: [String: 筋型] = [
		"９": .９, "８": .８, "７": .７, "６": .６, "５": .５, "４": .４, "３": .３, "２": .２, "１": .１
	]
	static let 筋記号表: [筋型: String] = [
		.９: "９", .８: "８", .７: "７", .６: "６", .５: "５", .４: "４", .３: "３", .２: "２", .１: "１"
	]
	var string: String {
		return Self.筋記号表[self]!
	}
	init?(number: Int8) {
		guard let 筋 = 筋型(rawValue: 9 - number) else { return nil }
		self = 筋
	}
	var description: String {
		return self.string
	}
}

enum 段型 : Int8, Equatable, CaseIterable, CustomStringConvertible {
	case 一, 二, 三, 四, 五, 六, 七, 八, 九
	static let 記号段表: [String: 段型] = [
		"一": .一, "二": .二, "三": .三, "四": .四, "五": .五, "六": .六, "七": .七, "八": .八, "九": .九
	]
	static let 段記号表: [段型: String] = [
		.一: "一", .二: "二", .三: "三", .四: "四", .五: "五", .六: "六", .七: "七", .八: "八", .九: "九"
	]
	var string: String {
		return Self.段記号表[self]!
	}
	static let 先手陣: [段型] = [.七, .八, .九]
	static let 後手陣: [段型] = [.一, .二, .三]
	init?(number: Int8) {
		guard let 段 = 段型(rawValue: number - 1) else { return nil }
		self = 段
	}
	func 敵陣判定(先手後手: 先手後手型) -> Bool {
		switch 先手後手 {
		case .先手: return Self.後手陣.contains(self)
		case .後手: return Self.先手陣.contains(self)
		}
	}
	var description: String {
		return self.string
	}
}

enum 先手後手型: Int8, Equatable, CustomStringConvertible {
	case 先手, 後手
	static let 記号先後表: [String: 先手後手型] = [
		"▲": .先手, "▽": .後手
	]
	static let 先後記号表: [先手後手型: String] = [
		.先手: "▲", .後手: "▽"
	]
	var symbol: String {
		return Self.先後記号表[self]!
	}
	var string: String {
		switch self {
		case .先手: return "先手"
		case .後手: return "後手"
		}
	}
	var 順方向: Int8 {
		switch self {
		case .先手: return 1
		case .後手: return -1
		}
	}
	var 敵方: 先手後手型 {
		switch self {
		case .先手: return .後手
		case .後手: return .先手
		}
	}
	var description: String {
		return self.string
	}
}

enum 位置型: Int8, CaseIterable, Equatable, CustomStringConvertible {
	case ９一, ８一, ７一, ６一, ５一, ４一, ３一, ２一, １一
	case ９二, ８二, ７二, ６二, ５二, ４二, ３二, ２二, １二
	case ９三, ８三, ７三, ６三, ５三, ４三, ３三, ２三, １三
	case ９四, ８四, ７四, ６四, ５四, ４四, ３四, ２四, １四
	case ９五, ８五, ７五, ６五, ５五, ４五, ３五, ２五, １五
	case ９六, ８六, ７六, ６六, ５六, ４六, ３六, ２六, １六
	case ９七, ８七, ７七, ６七, ５七, ４七, ３七, ２七, １七
	case ９八, ８八, ７八, ６八, ５八, ４八, ３八, ２八, １八
	case ９九, ８九, ７九, ６九, ５九, ４九, ３九, ２九, １九
	var 筋: 筋型 {
		return 筋型(rawValue: self.rawValue % 9)!
	}
	var 段: 段型 {
		return 段型(rawValue: self.rawValue / 9)!
	}
	init(筋: 筋型, 段: 段型) {
		self = 位置型(rawValue: 段.rawValue * 9 + 筋.rawValue)!
	}
	var string: String {
		return 筋.string + 段.string
	}
	var description: String {
		return self.string
	}
}

enum 駒型: Int8, Equatable, CustomStringConvertible {
	case 歩, 香, 桂, 銀, 金, 角, 飛, 玉
	static let 記号駒表: [String: 駒型] = [
		"歩": .歩, "香": .香, "桂": .桂, "銀": .銀, "金": .金, "角": .角, "飛": .飛, "玉": .玉
	]
	static let 駒記号表: [駒型: String] = [
		.歩: "歩", .香: "香", .桂: "桂", .銀: "銀", .金: "金", .角: "角", .飛: "飛", .玉: "玉"
	]
	var description: String {
		return Self.駒記号表[self]!
	}
	var 成駒面: 駒面型? {
		switch self {
		case .歩: return .と
		case .香: return .杏
		case .桂: return .圭
		case .銀: return .全
		case .金: return nil
		case .角: return .馬
		case .飛: return .竜
		case .玉: return nil
		}
	}
	var 駒面列: [駒面型] {
		switch self {
		case .歩: return [.歩, .と]
		case .香: return [.香, .杏]
		case .桂: return [.桂, .圭]
		case .銀: return [.銀, .全]
		case .金: return [.金]
		case .角: return [.角, .馬]
		case .飛: return [.飛, .竜]
		case .玉: return [.玉]
		}
	}
	var 表: 駒面型 {
		switch self {
		case .歩: return .歩
		case .香: return .香
		case .桂: return .桂
		case .銀: return .銀
		case .金: return .金
		case .角: return .角
		case .飛: return .飛
		case .玉: return .玉
		}
	}
}

enum 駒面型: Int8, Equatable, CustomStringConvertible {
	case 歩, 香, 桂, 銀, 金, 角, 飛, 玉
	case と, 杏, 圭, 全, 馬, 竜
	static let 記号駒面表: [String: 駒面型] = [
		"歩": .歩, "香": .香, "桂": .桂, "銀": .銀, "金": .金, "角": .角, "飛": .飛, "玉": .玉,
		"と": .と, "杏": .杏, "圭": .圭, "全": .全, "馬": .馬, "竜": .竜
	]
	static let 駒面記号表: [駒面型: String] = [
		.歩: "歩", .香: "香", .桂: "桂", .銀: "銀", .金: "金", .角: "角", .飛: "飛", .玉: "玉",
		.と: "と", .杏: "杏", .圭: "圭", .全: "全", .馬: "馬", .竜: "竜"
	]
	var 駒: 駒型 {
		switch self {
		case .歩, .と: return .歩
		case .香, .杏: return .香
		case .桂, .圭: return .桂
		case .銀, .全: return .銀
		case .金: return .金
		case .角, .馬: return .角
		case .飛, .竜: return .飛
		case .玉: return .玉
		}
	}
	var 単一移動オフセット列: [(x: Int8, y: Int8)] {
		switch self {
		case .歩: return [(0, -1)]
		case .香: return []
		case .桂: return [(-1, -2), (1, -2)]
		case .銀: return [(-1, -1), (0, -1), (1, -1), (-1, 1), (1, 1)]
		case .金: return [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (0, -1)]
		case .角: return []
		case .飛: return []
		case .玉: return [(-1, -1), (0, -1), (1, -1), (1, 0), (-1, 0), (-1, 1), (0, 1), (1, 1)]
		case .と: return [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (0, -1)]
		case .杏: return [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (0, -1)]
		case .圭: return [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (0, -1)]
		case .全: return [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (0, -1)]
		case .馬: return [(0, -1), (-1, 0), (1, 0), (0, 1)]
		case .竜: return [(-1, -1), (1, -1), (-1, 1), (1, 1)]
		}
	}
	var 連続移動ベクトル列: [(x: Int8, y: Int8)] {
		switch self {
		case .歩, .桂, .銀, .金, .玉, .と, .杏, .圭, .全: return []
		case .香: return [(0, -1)]
		case .角: return [(-1, -1), (1, -1), (-1, 1), (1, 1)]
		case .飛: return [(0, -1), (-1, 0), (1, 0), (0, 1)]
		case .馬: return [(-1, -1), (1, -1), (-1, 1), (1, 1)]
		case .竜: return [(0, -1), (-1, 0), (1, 0), (0, 1)]
		}
	}
	func 移動可能位置列(手番: 先手後手型, 位置: 位置型) -> [位置型] {
		var 位置列 = [位置型]()
		let vy = 手番.順方向
		let 筋 = 位置.筋.rawValue
		let 段 = 位置.段.rawValue
		for offset in self.単一移動オフセット列 {
			if let 筋 = 筋型(rawValue: 筋 + offset.x),
			   let 段 = 段型(rawValue: 段 + (offset.y * vy)) {
				位置列.append(位置型(筋: 筋, 段: 段))
		   }
		}
		for vector in self.連続移動ベクトル列 {
			var x = 位置.筋.rawValue + vector.x
			var y = 位置.段.rawValue + (vector.y * vy)
			while let 筋 = 筋型(rawValue: x), let 段 = 段型(rawValue: y) {
				位置列.append(位置型(筋: 筋, 段: 段))
				x += vector.x
				y += (vector.y * vy)
			}
		}
		return 位置列
	}
	var 成ることが可能: Bool {
		switch self {
		case .歩, .香, .桂, .銀, .角, .飛: return true
		case .金, .玉, .と, .杏, .圭, .全, .馬, .竜: return false
		}
	}
	var 成駒か: Bool {
		switch self {
		case .と, .杏, .圭, .全, .馬, .竜: return true
		default: return false
		}
	}
	var 成駒: 駒面型 {
		switch self {
		case .歩: return .と
		case .香: return .杏
		case .桂: return .圭
		case .角: return .馬
		case .飛: return .竜
		case .金, .玉: fatalError()
		default: return self
		}
	}
	func 配置禁則判定(先手後手: 先手後手型, 段: 段型) -> Bool {
		switch (先手後手, self) {
		case (.先手, .歩): return (段 == .一)
		case (.先手, .香): return (段 == .一)
		case (.先手, .桂): return (段 == .一 || 段 == .二)
		case (.後手, .歩): return (段 == .九)
		case (.後手, .香): return (段 == .九)
		case (.後手, .桂): return (段 == .九 || 段 == .八)
		default: return false
		}
	}
	var description: String {
		return Self.駒面記号表[self]!
	}
}

enum 升型: Int8, Equatable, CustomStringConvertible {
	case 空
	case 先歩, 先香, 先桂, 先銀, 先金, 先角, 先飛, 先玉
	case 先と, 先杏, 先圭, 先全, 先馬, 先竜
	case 後歩, 後香, 後桂, 後銀, 後金, 後角, 後飛, 後玉
	case 後と, 後杏, 後圭, 後全, 後馬, 後竜
	static let 記号升表: [String: 升型] = [
		"・": .空,
		"▲歩": .先歩, "▲香": .先香, "▲桂": .先桂, "▲銀": .先銀, "▲金": .先金, "▲角": .先角, "▲飛": .先飛, "▲玉": .先玉,
		"▲と": .先と, "▲杏": .先杏, "▲圭": .先圭, "▲全": .先全, "▲馬": .先馬, "▲竜": .先竜,
		"▽歩": .後歩, "▽香": .後香, "▽桂": .後桂, "▽銀": .後銀, "▽金": .後金, "▽角": .後角, "▽飛": .後飛, "▽玉": .後玉,
		"▽と": .後と, "▽杏": .後杏, "▽圭": .後圭, "▽全": .後全, "▽馬": .後馬, "▽竜": .後竜,
	]
	static let 升記号表: [升型: String] = [
		.空: "　・",
		.先歩: "▲歩", .先香: "▲香", .先桂: "▲桂", .先銀: "▲銀", .先金: "▲金", .先角: "▲角", .先飛: "▲飛", .先玉: "▲玉",
		.先と: "▲と", .先杏: "▲杏", .先圭: "▲圭", .先全: "▲全", .先馬: "▲馬", .先竜: "▲竜",
		.後歩: "▽歩", .後香: "▽香", .後桂: "▽桂", .後銀: "▽銀", .後金: "▽金", .後角: "▽角", .後飛: "▽飛", .後玉: "▽玉",
		.後と: "▽と", .後杏: "▽杏", .後圭: "▽圭", .後全: "▽全", .後馬: "▽馬", .後竜: "▽竜",
	]
	init(先手後手: 先手後手型, 駒面: 駒面型) {
		switch (先手後手, 駒面) {
		case (.先手, .歩): self = 升型.先歩
		case (.先手, .香): self = 升型.先香
		case (.先手, .桂): self = 升型.先桂
		case (.先手, .銀): self = 升型.先銀
		case (.先手, .金): self = 升型.先金
		case (.先手, .角): self = 升型.先角
		case (.先手, .飛): self = 升型.先飛
		case (.先手, .玉): self = 升型.先玉
		case (.先手, .と): self = 升型.先と
		case (.先手, .杏): self = 升型.先杏
		case (.先手, .圭): self = 升型.先圭
		case (.先手, .全): self = 升型.先全
		case (.先手, .馬): self = 升型.先馬
		case (.先手, .竜): self = 升型.先竜
		case (.後手, .歩): self = 升型.後歩
		case (.後手, .香): self = 升型.後香
		case (.後手, .桂): self = 升型.後桂
		case (.後手, .銀): self = 升型.後銀
		case (.後手, .金): self = 升型.後金
		case (.後手, .角): self = 升型.後角
		case (.後手, .飛): self = 升型.後飛
		case (.後手, .玉): self = 升型.後玉
		case (.後手, .と): self = 升型.後と
		case (.後手, .杏): self = 升型.後杏
		case (.後手, .圭): self = 升型.後圭
		case (.後手, .全): self = 升型.後全
		case (.後手, .馬): self = 升型.後馬
		case (.後手, .竜): self = 升型.後竜
		}
	}
	var 駒面: 駒面型? {
		switch self {
		case .空: return nil
		case .先歩, .後歩: return .歩
		case .先香, .後香: return .香
		case .先桂, .後桂: return .桂
		case .先銀, .後銀: return .銀
		case .先金, .後金: return .金
		case .先角, .後角: return .角
		case .先飛, .後飛: return .飛
		case .先玉, .後玉: return .玉
		case .先と, .後と: return .と
		case .先杏, .後杏: return .杏
		case .先圭, .後圭: return .圭
		case .先全, .後全: return .全
		case .先馬, .後馬: return .馬
		case .先竜, .後竜: return .竜
		}
	}
	var 先手後手: 先手後手型? {
		switch self {
		case .先歩, .先香, .先桂, .先銀, .先金, .先角, .先飛, .先玉, .先と, .先杏, .先圭, .先全, .先馬, .先竜: return .先手
		case .後歩, .後香, .後桂, .後銀, .後金, .後角, .後飛, .後玉, .後と, .後杏, .後圭, .後全, .後馬, .後竜: return .後手
		case .空: return nil
		}
	}
	var description: String {
		return Self.升記号表[self]!
	}
}

extension Array where Element == 升型 {
	subscript(位置: 位置型) -> 升型 {
		get { return self[Int(位置.rawValue)] }
		set { self[Int(位置.rawValue)] = newValue }
	}
}

typealias 持駒表型 = [駒型: Int]

extension 持駒表型 {
	var string: String {
		var string = "持駒: "
		let keys = self.keys.sorted { $0.rawValue > $1.rawValue }
		for key in keys {
			string += key.description
			if let count = self[key], count > 1 {
				string += String(count)
			}
		}
		if self.count == 0 {
			string += "なし"
		}
		return string
	}
	mutating func add(駒: 駒型) {
		self[駒] = (self[駒] ?? 0) + 1
	}
	mutating func remove(駒: 駒型) {
		self[駒] = (self[駒] ?? 0) - 1
	}
	static func scan(scanner: Scanner) throws -> 持駒表型 {
		var 持駒表: 持駒表型 = [:]
		guard let _ = scanner.scanString("持駒:") else { throw ScanError(scanner: scanner, message: "expected 持駒:") }
		if let _ = scanner.scanString("なし") {
		}
		else {
			while let 駒 = scanner.scan(駒型.記号駒表) {
				let count = scanner.scanInt() ?? 1
				持駒表[駒] = count
			}
		}
		guard let _ = scanner.scanCharacters(from: CharacterSet.newlines) else { throw ScanError(scanner: scanner, message: "Unexpected trailing characters") }
		return 持駒表
	}
}

class 局面型: Equatable, CustomStringConvertible {
	static let 総升数 = 81
	var 升列: [升型]
	var 手番: 先手後手型
	var 先手持駒: 持駒表型 = [:]
	var 後手持駒: 持駒表型 = [:]
	init(局面: 局面型) {
		self.升列 = 局面.升列
		self.先手持駒 = 局面.先手持駒
		self.後手持駒 = 局面.後手持駒
		self.手番 = 局面.手番
	}
	init(string: String) throws {
		var 升列 = [升型]()
		let scanner = Scanner(string: string)
		scanner.charactersToBeSkipped = .whitespaces
		let 後手持駒 = try 持駒表型.scan(scanner: scanner)
		for _ in 段型.allCases {
			var 段升列 = [升型]()
			for _ in 筋型.allCases {
				if let _ = scanner.scanString("|"), let 升 = scanner.scan(升型.記号升表) {
					段升列.append(升)
				}
				else {
					throw ScanError(scanner: scanner, message: "expected 升型記号")
				}
			}
			let _ = scanner.scanString("|")
			升列 += 段升列
			_ = scanner.scanUpToCharacters(from: CharacterSet.newlines)
			_ = scanner.scanCharacters(from: CharacterSet.newlines)
		}
		let 先手持駒 = try 持駒表型.scan(scanner: scanner)
		let 手番 = try scanner.scan手番()
		self.升列 = 升列
		self.先手持駒 = 先手持駒
		self.後手持駒 = 後手持駒
		self.手番 = 手番
	}
	convenience init(手合: 手合型) {
		switch 手合 {
		case .平手:
			try! self.init(string:
				"""
				持駒: なし
				|▽香|▽桂|▽銀|▽金|▽玉|▽金|▽銀|▽桂|▽香|
				|　・|▽飛|　・|　・|　・|　・|　・|▽角|　・|
				|▽歩|▽歩|▽歩|▽歩|▽歩|▽歩|▽歩|▽歩|▽歩|
				|　・|　・|　・|　・|　・|　・|　・|　・|　・|
				|　・|　・|　・|　・|　・|　・|　・|　・|　・|
				|　・|　・|　・|　・|　・|　・|　・|　・|　・|
				|▲歩|▲歩|▲歩|▲歩|▲歩|▲歩|▲歩|▲歩|▲歩|
				|　・|▲角|　・|　・|　・|　・|　・|▲飛|　・|
				|▲香|▲桂|▲銀|▲金|▲玉|▲金|▲銀|▲桂|▲香|
				持駒: なし
				手番: 先手
				"""
			)
		}
	}
	subscript(位置: 位置型) -> 升型 {
		get { return self.升列[位置] }
		set { self.升列[位置] = newValue }
	}
	func 探索(升群: Set<升型>) -> [位置型] {
		return zip(self.升列, 位置型.allCases).filter { 升群.contains($0.0) }.map { $0.1 }
	}
	func 持駒表(先手後手: 先手後手型) -> 持駒表型 {
		switch 先手後手 {
		case .先手: return self.先手持駒
		case .後手: return self.後手持駒
		}
	}
	func 筋升列(筋: 筋型) -> [升型] {
		return 段型.allCases.map { 段 in self[位置型(筋: 筋, 段: 段)] }
	}
	func 歩の数(手番: 先手後手型, 筋: 筋型) -> Int {
		return 筋升列(筋: 筋).filter { $0.先手後手 == self.手番 && $0.駒面 == .歩 }.count
	}
	func 実行(指手: 指手型) -> 局面型? {
		let 次局面 = 局面型(局面: self)
		switch 指手 {
		case .動(先手後手: let 先手後手, 移動元: let 移動元, 移動先: let 移動先, 駒面: let 駒面, 成: let 成):
			let 移動元升 = 次局面[移動元]
			let 移動先升 = 次局面[移動先]
			次局面[移動元] = .空
			次局面[移動先] = 升型(先手後手: 先手後手, 駒面: 成 ? 駒面.成駒 : 駒面)
			assert(移動元升.駒面?.駒 == 駒面.駒)
			if let 捕獲駒 = 移動先升.駒面?.駒, 移動先升.先手後手 == self.手番.敵方 {
				switch self.手番 {
				case .先手: 次局面.先手持駒.add(駒: 捕獲駒)
				case .後手: 次局面.後手持駒.add(駒: 捕獲駒)
				}
			}
		case .打(先手後手: let 先手後手, 位置: let 位置, 駒: let 駒):
			switch 先手後手 {
			case .先手: 次局面.先手持駒.remove(駒: 駒)
			case .後手: 次局面.後手持駒.remove(駒: 駒)
			}
			assert(次局面[位置] == .空)
			次局面[位置] = 升型(先手後手: 先手後手, 駒面: 駒.表)
		case .終(終局理由: let 終局理由, 勝者: let 勝者):
			print("終局:", "終局理由=", 終局理由, "勝者=", 勝者 ?? "nil")
			return nil
		}
		次局面.手番 = self.手番.敵方
		return 次局面
	}
	func 指定位置の駒が移動可能な位置列(指定位置: 位置型, 移動先が自駒の場合も含む: Bool) -> [位置型] {
		var 位置列 = [位置型]()
		let 升 = self.升列[指定位置]
		if let 駒面 = 升.駒面, let 先手後手 = 升.先手後手 {
			let direction = 先手後手.順方向
			let 筋 = 指定位置.筋.rawValue
			let 段 = 指定位置.段.rawValue
			for offset in 駒面.単一移動オフセット列 {
				if let 筋 = 筋型(rawValue: 筋 + offset.x),
				   let 段 = 段型(rawValue: 段 + (offset.y * direction)) {
					let 移動先 = 位置型(筋: 筋, 段: 段)
					switch self[移動先].先手後手 {
					case 先手後手:
						if 移動先が自駒の場合も含む {
							位置列.append(移動先)
						}
					default:
						位置列.append(移動先)
					}
				}
			}
			vector: for vector in 駒面.連続移動ベクトル列 {
				var x = 指定位置.筋.rawValue + vector.x
				var y = 指定位置.段.rawValue + (vector.y * direction)
				while let 筋 = 筋型(rawValue: x), let 段 = 段型(rawValue: y) {
					let 移動先位置 = 位置型(筋: 筋, 段: 段)
					let 移動先升 = self.升列[移動先位置]
					let 自駒 = 先手後手
					let 敵駒 = 先手後手.敵方
					switch 移動先升.先手後手 {
					case 自駒:
						if 移動先が自駒の場合も含む {
							位置列.append(移動先位置)
						}
						continue vector
					case 敵駒:
						位置列.append(移動先位置)
						continue vector
					default:
						位置列.append(移動先位置)
					}
					x += vector.x
					y += (vector.y * direction)
				}
			}
		}
		return 位置列
	}
	func 全移動可能位置列(手番: 先手後手型, 移動先が自駒の場合も含む: Bool) -> Set<位置型> {
		var 位置列 = Set<位置型>()
		for (位置, 升) in zip(位置型.allCases, self.升列) {
			if 升.先手後手 == 手番 {
				位置列.formUnion(self.指定位置の駒が移動可能な位置列(指定位置: 位置, 移動先が自駒の場合も含む: 移動先が自駒の場合も含む))
			}
		}
		return 位置列
	}
	func 可能指手列(位置列: [位置型] = 位置型.allCases) -> [指手型] {
		let 手番 = self.手番
		var 指手列 = [指手型]()
		for 位置 in 位置列 {
			let 升 = self.升列[位置]
			switch 升 {
			case .空:
				let 持駒表 = self.持駒表(先手後手: 手番)
				for (駒, 駒数) in 持駒表 where 駒数 > 0 {
					if !駒.表.配置禁則判定(先手後手: 手番, 段: 位置.段) { // 打ち歩詰め以外の禁則対策
						if !(駒 == .歩 && self.歩の数(手番: 手番, 筋: 位置.筋) > 0) { // 二歩
							指手列.append(指手型.打(先手後手: 手番, 位置: 位置, 駒: 駒))
						}
					}
				}
			default:
				if let 先手後手 = 升.先手後手, 先手後手 == 手番, let 駒面 = 升.駒面 {
					let 位置列 = self.指定位置の駒が移動可能な位置列(指定位置: 位置, 移動先が自駒の場合も含む: false)
					for 移動先 in 位置列 {
						if self[移動先].先手後手 != 手番 {
							if 移動先.段.敵陣判定(先手後手: 手番) && 駒面.成ることが可能 {
								指手列.append(指手型.動(先手後手: 手番, 移動元: 位置, 移動先: 移動先, 駒面: 駒面, 成: true))
							}
							if !駒面.配置禁則判定(先手後手: 手番, 段: 移動先.段) {
								指手列.append(指手型.動(先手後手: 手番, 移動元: 位置, 移動先: 移動先, 駒面: 駒面, 成: false))
							}
						}
					}
				}
			}
		}
		return 指手列
	}
	func 指定位置に移動可能な駒の位置列(手番: 先手後手型, 指定位置: 位置型) -> [位置型] {
		let 自駒位置列 = 位置型.allCases.filter { self[$0].先手後手 == 手番 }
		return 自駒位置列.filter { self.指定位置の駒が移動可能な位置列(指定位置: $0, 移動先が自駒の場合も含む: false).contains(指定位置) }
	}
	func 駒が移動可能な位置列(手番: 先手後手型) -> [(元: 位置型, 先: 位置型)] {
		return zip(self.升列, 位置型.allCases).filter { $0.0.先手後手 == 手番 }.map { (升, 元) in self.指定位置の駒が移動可能な位置列(指定位置: 元, 移動先が自駒の場合も含む: false).map { 先 in (元, 先) } }.flatMap { $0 }
	}
	func 駒位置表生成(先手後手: 先手後手型) -> [駒面型: [位置型]] {
		var 駒位置表 = [駒面型: [位置型]]()
		for (位置, 升) in zip(位置型.allCases, self.升列) {
			if let 駒面 = 升.駒面, 升.先手後手 == 先手後手 {
				駒位置表[駒面] = (駒位置表[駒面] ?? []) + [位置]
			}
		}
		return 駒位置表
	}
	private(set) lazy var 駒位置表: [先手後手型: [駒面型: [位置型]]] = {
		let 先手駒位置表 = self.駒位置表生成(先手後手: .先手)
		let 後手駒位置表 = self.駒位置表生成(先手後手: .後手)
		return [.先手: 先手駒位置表, .後手: 後手駒位置表]
	}()
	func 玉の位置(先手後手: 先手後手型) -> 位置型? {
		return self.駒位置表[先手後手]?[.玉]?.first
	}
	func 王を取る指手列(手番: 先手後手型) -> [指手型] {
		var 指手列 = [指手型]()
		if let 敵玉の位置 = self.玉の位置(先手後手: 手番.敵方) {
			if self.指定位置に移動可能な駒の位置列(手番: 手番, 指定位置: 敵玉の位置).count > 0 {
				指手列.append(指手型.終(終局理由: .王手放置, 勝者: 手番))
			}
		}
		return 指手列
	}
	func 王手探索() -> [指手型] {
		return self.可能指手列().filter { self.実行(指手: $0)?.王を取る指手列(手番: self.手番).count ?? 0 > 0 }
	}
	var description: String {
		return """
		\(self.後手持駒.string)
		\(段型.allCases.map { 段 in "|" + 筋型.allCases.map { 筋 in self[位置型(筋: 筋, 段: 段)].description }.joined(separator: "|") + "|" }.joined(separator: "\r"))
		\(self.先手持駒.string)
		手番: \(self.手番.string)
		"""
	}
	var 全次局面列: [局面型] {
		return self.可能指手列().compactMap { self.実行(指手: $0) }
	}
	func 可能局面探索(世代: Int) async -> [局面型] {
		let 全次局面列 = self.全次局面列
		guard 世代 > 0 else { return 全次局面列 }
		var 局面列 = 全次局面列
		for 局面 in 全次局面列 {
			局面列 += await 局面.可能局面探索(世代: 世代 - 1)
		}
		return 局面列
	}
	var 詰判定: Bool {
		if let 玉の位置 = self.玉の位置(先手後手: self.手番) {
			let 玉の移動可能位置列 = Set(self.指定位置の駒が移動可能な位置列(指定位置: 玉の位置, 移動先が自駒の場合も含む: false))
			let 玉の移動不可位置列 = Set(self.全移動可能位置列(手番: self.手番.敵方, 移動先が自駒の場合も含む: true))
			print("可能=", 玉の移動可能位置列)
			print("不可=", 玉の移動不可位置列)
			print(玉の移動可能位置列.subtracting(玉の移動不可位置列))
			return 玉の移動可能位置列.subtracting(玉の移動不可位置列).count == 0
		}
		return false
	}
	static func == (lhs: 局面型, rhs: 局面型) -> Bool {
		return lhs.升列 == rhs.升列 && lhs.手番 == rhs.手番 && lhs.先手持駒 == rhs.先手持駒 && lhs.後手持駒 == rhs.後手持駒
	}
}

enum 手合型 {
	case 平手
}

class 対局型 {
	var 局面: 局面型
	init(手合: 手合型) {
		self.局面 = 局面型(手合: 手合)
	}
	/*
	init(手合: 手合型) {
		self.局面 = try! 局面型(string:
			"""
			持駒: なし
			|▽香|▽桂|▽銀|▽金|▽玉|▽金|▽銀|▽桂|▽香|
			|　・|▽飛|　・|　・|　・|　・|　・|▽角|　・|
			|▽歩|▽歩|▽歩|▽歩|▽歩|▽歩|▽歩|▽歩|▽歩|
			|　・|　・|　・|　・|　・|　・|　・|　・|　・|
			|　・|　・|　・|　・|　・|　・|　・|　・|　・|
			|　・|　・|　・|　・|　・|　・|　・|　・|　・|
			|▲歩|▲歩|▲歩|▲歩|▲歩|▲歩|▲歩|▲歩|▲歩|
			|　・|▲角|　・|　・|　・|　・|　・|▲飛|　・|
			|▲香|▲桂|▲銀|▲金|▲玉|▲金|▲銀|▲桂|▲香|
			持駒: なし
			手番: 先手
			"""
		)
	}
	*/
	init?(string: String) {
		var 局面: 局面型?
		let scanner = Scanner(string: string)
		scanner.charactersToBeSkipped = nil
		var 手番: 先手後手型?
		while !scanner.isAtEnd {
			defer {
				let a = scanner.scanUpToCharacters(from: CharacterSet.newlines)
				let b = scanner.scanCharacters(from: CharacterSet.newlines)
				print("a=", a ?? "nil")
				print("b=", b ?? "nil")
				print("[[", string[scanner.currentIndex...], "]]")
			}
			if let _ = scanner.scanString("'") {
				let comment = scanner.scanUpToCharacters(from: CharacterSet.newlines)
				print("'" + (comment ?? "nil"))
			}
			else if let _ = scanner.scanString("$") {
				let line = scanner.scanUpToCharacters(from: CharacterSet.newlines)
				print("$" + (line ?? "nil"))
			}
			else if let _ = scanner.scanString("N") {
				let name = scanner.scanUpToCharacters(from: CharacterSet.newlines)
				print("N" + (name ?? "nil"))
			}
			else if let _ = scanner.scanString("PI") {
				print("手合:")
				局面 = 局面型(手合: .平手)
			}
			else if 手番 == nil, let 先手後手 = scanner.scan(["+", "-"]) {
				print("先手後手:")
				switch 先手後手 {
				case "+": 手番 = .先手; print("先手番")
				case "-": 手番 = .後手; print("後手番")
				default: break
				}
			}
			else if let 先手後手 = scanner.scan(["+", "-"]) {
				print("指手:", 先手後手)
				if let d1 = scanner.scan(Self.digits), let d2 = scanner.scan(Self.digits),
				   let d3 = scanner.scan(Self.digits), let d4 = scanner.scan(Self.digits) {
					if let 元筋 = 筋型(number: d1), let 元段 = 段型(number: d2),
					   let 先筋 = 筋型(number: d3), let 先段 = 段型(number: d4),
					   let 駒面 = scanner.scan(Self.駒面), let 現局面 = 局面 {
						let 元位置 = 位置型(筋: 元筋, 段: 元段)
						let 先位置 = 位置型(筋: 先筋, 段: 先段)
						let 元升 = 現局面[元位置]
						let 先升 = 現局面[先位置]
						unused(先升)
						let 成 = 元升.駒面 != 駒面
						print(元位置, 先位置, 駒面, 成)
						assert(元升.駒面?.駒 == 駒面.駒)
						let 指手 = 指手型.動(先手後手: 現局面.手番, 移動元: 元位置, 移動先: 先位置, 駒面: 駒面, 成: 成)
						print(現局面)
						print(指手)
						let 次局面 = 現局面.実行(指手: 指手)
						if let 次局面 { print(次局面) }
						局面 = 次局面
					}
					else if d1 == 0 && d2 == 0, let 筋 = 筋型(number: d3), let 段 = 段型(number: d4), let 駒面 = scanner.scan(Self.駒面), let 現局面 = 局面 {
						let 指手 = 指手型.打(先手後手: 現局面.手番, 位置: 位置型(筋: 筋, 段: 段), 駒: 駒面.駒)
						let 次局面 = 現局面.実行(指手: 指手)
						if let 次局面 { print(次局面) }
						局面 = 次局面
					}
					else {
						if let 局面 { print(局面) }
						fatalError("Unexpected condition")
					}
				}
			}
			else {
				print("他:")
				print(string[scanner.currentIndex...])
			}
		}
		return nil
	}
	// FU,KY,KE,GI,KI,KA,HI,OU
	// TO,NY,NK,NG,UM,RY
	static let digits: [String: Int8] = ["0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9]
	static let 駒面: [String: 駒面型] = [
		"FU": .歩, "KY": .香, "KE": .桂, "GI": .銀, "KI": .金, "KA": .角, "HI": .飛, "OU": .玉,
		"TO": .と, "NY": .杏, "NK": .圭, "NG": .全, "UM": .馬, "RY": .竜
	]
}

enum 終局理由型: Int8, Equatable, CustomStringConvertible {
	case 投了
	case 詰
	case 王手放置
	var description: String {
		switch self {
		case .投了: return "投了"
		case .詰: return "詰"
		case .王手放置: return "王手放置"
		}
	}
}

enum 指手型: Hashable, CustomStringConvertible {
	case 動(先手後手: 先手後手型, 移動元: 位置型, 移動先: 位置型, 駒面: 駒面型, 成: Bool)
	case 打(先手後手: 先手後手型, 位置: 位置型, 駒: 駒型)
	case 終(終局理由: 終局理由型, 勝者: 先手後手型?)
	var description: String {
		switch self {
		case .動(先手後手: let 先手後手, 移動元: let 移動元, 移動先: let 移動先, 駒面: let 駒面, 成: let 成):
			return "\(先手後手): \(移動元) -> \(移動先) \(駒面) \(成 ? "成" : "不成")"
		case .打(先手後手: let 先手後手, 位置: let 位置, 駒: let 駒):
			return "\(先手後手): \(位置) \(駒) 打"
		case .終(終局理由: let 終局理由, 勝者: let 勝者):
			if let 勝者 = 勝者 {
				return "まで \(勝者) の勝ち [\(終局理由)]"
			}
			else {
				return "まで勝敗つかず"
			}
		}
	}
	var code: String {
		switch self {
		case .動(先手後手: let 先手後手, 移動元: let 移動元, 移動先: let 移動先, 駒面: let 駒面, 成: let 成):
			return ".動(先手後手: .\(先手後手.string), 移動元: .\(移動元), 移動先: .\(移動先), 駒面: .\(駒面), 成: \(成 ? "true" : "false"))"
		case .打(先手後手: let 先手後手, 位置: let 位置, 駒: let 駒):
			return ".打(先手後手: .\(先手後手.string), 位置: .\(位置), 駒: .\(駒))"
		case .終(終局理由: let 終局理由, 勝者: let 勝者):
			let 勝者表記 = 勝者.flatMap { $0.string } ?? "nil"
			return ".終(終局理由: .\(終局理由), 勝者: .\(勝者表記))"
		}
	}
	static func == (lhs: 指手型, rhs: 指手型) -> Bool {
		switch (lhs, rhs) {
		case (.動(let 先後L, let 移動元L, let 移動先L, let 駒面L, let 成L), .動(let 先後R, let 移動元R, let 移動先R, let 駒面R, let 成R)):
			return 先後L == 先後R && 移動元L == 移動元R && 移動先L == 移動先R && 駒面L == 駒面R && 成L == 成R
		case (.打(let 先後L, let 位置L, let 駒L), .打(let 先後R, let 位置R, let 駒R)):
			return 先後L == 先後R && 位置L == 位置R && 駒L == 駒R
		case (.終(let 終局理由L, let 勝者L), .終(let 終局理由R, let 勝者R)):
			return 終局理由L == 終局理由R && 勝者L == 勝者R
		default:
			return false
		}
	}
	func hash(into hasher: inout Hasher) {
		switch self {
		case .動(先手後手: let 先手後手, 移動元: let 移動元, 移動先: let 移動先, 駒面: let 駒面, 成: let 成):
			hasher.combine(先手後手)
			hasher.combine(移動元)
			hasher.combine(移動先)
			hasher.combine(駒面)
			hasher.combine(成)
		case .打(先手後手: let 先手後手, 位置: let 位置, 駒: let 駒):
			hasher.combine(先手後手)
			hasher.combine(位置)
			hasher.combine(駒)
		case .終(終局理由: let 終局理由, 勝者: let 勝者):
			hasher.combine(終局理由)
			hasher.combine(勝者)
		}
	}
}


extension Scanner {
	func scan<T>(_ pattern: [String: T]) -> T? {
		for (key, value) in pattern {
			if let _ = self.scanString(key) {
				return value
			}
		}
		return nil
	}
	func scan(_ strings: [String]) -> String? {
		for string in strings {
			if let _ = self.scanString(string) {
				return string
			}
		}
		return nil
	}
	func scan手番() throws -> 先手後手型 {
		guard let _ = self.scanString("手番:") else { throw ScanError(scanner: self, message: "expected 手番") }
		let 先手後手表: [String: 先手後手型] = ["先手": .先手, "後手": .後手]
		guard let 手番 = self.scan(先手後手表) else { throw ScanError(scanner: self, message: "expected '先手|後手'") }
		return 手番
	}
}

struct ScanError: Error, CustomStringConvertible {
	let string: String
	init(scanner: Scanner, message: String) {
		let string = scanner.string
		let block = string[scanner.currentIndex...]
		self.string = message + ". ^" + block
	}
	var description: String {
		return self.string
	}
}

extension Array where Element: Equatable {
	func indexes(of item: Element) -> [Int] {
		return self.enumerated().filter({ $0.element == item }).map { $0.offset }
	}
}

class CSAScanner {
	let scanner: Scanner
	init(string: String) {
		self.scanner = Scanner(string: string)
		self.scanner.charactersToBeSkipped = .whitespaces
	}
}
