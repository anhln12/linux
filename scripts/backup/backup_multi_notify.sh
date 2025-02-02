```
#!/bin/bash

# Cấu hình
SOURCE_DIRS=(
    "/path/to/source1"
    "/path/to/source2"
    "/path/to/source3"
)  # Danh sách thư mục cần backup

BACKUP_DIR="/path/to/backup"  # Thư mục lưu backup

TELEGRAM_BOT_TOKEN="your_bot_token"
TELEGRAM_CHAT_ID="your_chat_id"

LOG_FILE="/tmp/backup_log.txt"
echo "🔄 Bắt đầu sao lưu $(date)" > "$LOG_FILE"

# Lặp qua từng thư mục trong danh sách
for SOURCE in "${SOURCE_DIRS[@]}"; do
    FOLDER_NAME=$(basename "$SOURCE")
    BACKUP_NAME="${FOLDER_NAME}_backup_$(date +'%Y-%m-%d_%H-%M-%S').tar.gz"
    BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

    # Bắt đầu đo thời gian
    START_TIME=$(date +%s)

    echo "📂 Sao lưu: $SOURCE"
    tar -czf "$BACKUP_PATH" "$SOURCE" 2>/tmp/backup_error.log

    # Kết thúc đo thời gian
    END_TIME=$(date +%s)
    ELAPSED_TIME=$((END_TIME - START_TIME))
    MINUTES=$((ELAPSED_TIME / 60))
    SECONDS=$((ELAPSED_TIME % 60))

    # Tính dung lượng file backup (GB)
    BACKUP_SIZE_GB=$(du -bg "$BACKUP_PATH" | cut -f1)

    # Kiểm tra kết quả backup
    if [ $? -eq 0 ]; then
        echo "✅ $FOLDER_NAME: ${MINUTES} phút ${SECONDS} giây, ${BACKUP_SIZE_GB} GB" >> "$LOG_FILE"
    else
        echo "❌ $FOLDER_NAME: Sao lưu thất bại!" >> "$LOG_FILE"
    fi
done

# Đọc log & gửi thông báo Telegram
MESSAGE="📢 *Kết quả sao lưu:*\n$(cat "$LOG_FILE")"
curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
     -d "chat_id=$TELEGRAM_CHAT_ID" \
     -d "parse_mode=Markdown" \
     -d "text=$MESSAGE" > /dev/null

echo "📨 Đã gửi thông báo đến Telegram."
```
