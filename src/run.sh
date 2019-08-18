SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd "$SCRIPT_DIR"

# in-memory→ファイル
sqlite3 :memory: \
"create table T(C text);" \
"insert into T values('AAA');" \
".clone clone.db"

sqlite3 clone.db \
"select sql from sqlite_master;" \
".headers on" \
"select * from T;"

# ファイル→in-memory
sqlite3 :memory: \
".open clone.db" \
"select sql from sqlite_master;" \
".headers on" \
"select * from T;"

# ファイル→ファイル
sqlite3 clone.db ".clone clone_0.db"
cmp clone.db clone_0.db

# 空DBでやるとエラー
sqlite3 :memory: ".clone A.db"

# シェルコマンド
cp -au clone.db clone_cp.db

