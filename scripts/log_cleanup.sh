#!/bin/bash

# --- Cấu hình ---
FOLDER="/database/pgdata/12/main/log"
SIZE_LIMIT_GB=15
BOT_TOKEN=""
CHAT_ID=""

now=$(date '+%Y-%m-%d %H:%M:%S')
SYSTEM="DATABASE POSTGRES FINTECH"
IP="10.30.17.44"

# --- Hàm gửi tin nhắn Telegram ---
send_telegram() {
    local message="$1"
    curl -s -X POST "https://telegram.workers.dev/bot${BOT_TOKEN}/sendMessage" \
        -d chat_id="${CHAT_ID}" \
        -d text="$message" \
        -d parse_mode="HTML" > /dev/null
}

# --- Tính dung lượng thư mục (đơn vị GB, làm tròn về số nguyên) ---
folder_size=$(du -s "$FOLDER" | awk '{print int($1/1024/1024)}')

# --- Kiểm tra nếu lớn hơn SIZE_LIMIT_GB ---
if [ "$folder_size" -gt "$SIZE_LIMIT_GB" ]; then
    # Lấy danh sách file .log, sắp xếp theo thời gian chỉnh sửa (mới nhất đầu tiên)
    log_files=($(find "$FOLDER" -maxdepth 1 -type f -name "*.log" -printf "%T@ %p\n" | sort -nr | awk '{print $2}'))

    total_files=${#log_files[@]}

    if [ "$total_files" -le 15 ]; then
        echo "Không có file log nào cần xóa."
        exit 0
    fi

    # Xóa từ file thứ 16 trở đi
    delete_count=0
    for ((i=15; i<total_files; i++)); do
        rm -f "${log_files[$i]}" && ((delete_count++))
    done

    # Gửi thông báo Telegram
    msg="ℹ️ Information at ${now}%0A🖥️ System: <code>${SYSTEM}</code>%0A🔗 IP: ${IP}%0A📁 Folder: <code>${FOLDER}</code>%0A💾 Dung lượng: ${folder_size} GB >= 15 GB%0A🧹 Đã xóa ${delete_count} file .log (giữ lại 15 file mới nhất)."
    send_telegram "$msg"
else
    echo "Dung lượng $FOLDER là ${folder_size}GB < ${SIZE_LIMIT_GB}GB. Không cần xóa."
fi
