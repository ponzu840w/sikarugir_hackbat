# --- Makefile ---

# 出力されるコンパイル済みスクリプトファイル
TARGET_SCRIPT = hack/_open_mac_term.scpt

# 元となるソースファイル
SOURCE_SCRIPT = ./_open_mac_term.scpt_src

# デフォルトのターゲット (makeコマンド実行時に最初に実行されるルール)
all: $(TARGET_SCRIPT)

# メインのコンパイルルール
$(TARGET_SCRIPT): $(SOURCE_SCRIPT)
	@echo "Compiling $(SOURCE_SCRIPT) -> $(TARGET_SCRIPT)..."
	# 出力先ディレクトリ(hack/)が存在しない場合に作成します
	@mkdir -p $(@D)
	# osacompile を実行します
	osacompile -o $@ $<

# .PHONY は、'all' が実際のファイル名ではなくルール名であることを示します
.PHONY: all
