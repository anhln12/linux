```
#!/bin/bash

# Cấu hình
SOURCE_DIR="/path/to/source"    # Thư mục cần sao lưu
BACKUP_DIR="/path/to/backup"    # Thư mục lưu file backup
BACKUP_NAME="backup_$(date +'%Y-%m-%d_%H-%M-%S').tar.gz"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

TELEGRAM_BOT_TOKEN="your_bot_token"
TELEGRAM_CHAT_ID="your_chat_id"

# Bắt đầu đo thời gian
START_TIME=$(date +%s)

echo "🔄 Đang sao lưu dữ liệu..."
tar -czf "$BACKUP_PATH" "$SOURCE_DIR" 2>/tmp/backup_error.log

# Kết thúc đo thời gian
END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))
MINUTES=$((ELAPSED_TIME / 60))
SECONDS=$((ELAPSED_TIME % 60))

# Tính dung lượng file backup (GB)
BACKUP_SIZE_GB=$(du -bg "$BACKUP_PATH" | cut -f1)

# Kiểm tra kết quả backup
if [ $? -eq 0 ]; then
    MESSAGE="✅ *Sao lưu thành công!*\n📂 File: \`$BACKUP_NAME\`\n⏳ Thời gian: ${MINUTES} phút ${SECONDS} giây\n💾 Dung lượng: ${BACKUP_SIZE_GB} GB"
else
    MESSAGE="❌ *Sao lưu thất bại!*\n$(cat /tmp/backup_error.log)"
fi

# Gửi thông báo đến Telegram
curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
     -d "chat_id=$TELEGRAM_CHAT_ID" \
     -d "parse_mode=Markdown" \
     -d "text=$MESSAGE" > /dev/null

echo "📨 Đã gửi thông báo đến Telegram."

# Xóa file log lỗi nếu không có lỗi
[ $? -eq 0 ] && rm -f /tmp/backup_error.log
```


Dưới đây là phiên bản nâng cấp của script sao lưu + đo thời gian + tính dung lượng file backup, và gửi thông báo Telegram.

🔹 Cải tiến:
✅ Tính thời gian backup (phút & giây)
✅ Tính dung lượng file backup (GB)
✅ Gửi thông báo Telegram với thông tin chi tiết

🔹 Script: backup_notify.sh
bash
Sao chép
Chỉnh sửa
#!/bin/bash

# Cấu hình
SOURCE_DIR="/path/to/source"    # Thư mục cần sao lưu
BACKUP_DIR="/path/to/backup"    # Thư mục lưu file backup
BACKUP_NAME="backup_$(date +'%Y-%m-%d_%H-%M-%S').tar.gz"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

TELEGRAM_BOT_TOKEN="your_bot_token"
TELEGRAM_CHAT_ID="your_chat_id"

# Bắt đầu đo thời gian
START_TIME=$(date +%s)

echo "🔄 Đang sao lưu dữ liệu..."
tar -czf "$BACKUP_PATH" "$SOURCE_DIR" 2>/tmp/backup_error.log

# Kết thúc đo thời gian
END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))
MINUTES=$((ELAPSED_TIME / 60))
SECONDS=$((ELAPSED_TIME % 60))

# Tính dung lượng file backup (GB)
BACKUP_SIZE_GB=$(du -bg "$BACKUP_PATH" | cut -f1)

# Kiểm tra kết quả backup
if [ $? -eq 0 ]; then
    MESSAGE="✅ *Sao lưu thành công!*\n📂 File: \`$BACKUP_NAME\`\n⏳ Thời gian: ${MINUTES} phút ${SECONDS} giây\n💾 Dung lượng: ${BACKUP_SIZE_GB} GB"
else
    MESSAGE="❌ *Sao lưu thất bại!*\n$(cat /tmp/backup_error.log)"
fi

# Gửi thông báo đến Telegram
curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
     -d "chat_id=$TELEGRAM_CHAT_ID" \
     -d "parse_mode=Markdown" \
     -d "text=$MESSAGE" > /dev/null

echo "📨 Đã gửi thông báo đến Telegram."

# Xóa file log lỗi nếu không có lỗi
[ $? -eq 0 ] && rm -f /tmp/backup_error.log
🔹 Cách hoạt động:
Bắt đầu đo thời gian (START_TIME)
Thực hiện sao lưu với tar -czf
Kết thúc đo thời gian (END_TIME) và tính phút + giây
Tính dung lượng file backup (GB)
Gửi thông báo Telegram với các thông tin:
✅ Tên file backup
⏳ Thời gian thực hiện (phút & giây)
💾 Dung lượng file (GB)
❌ Báo lỗi nếu thất bại
