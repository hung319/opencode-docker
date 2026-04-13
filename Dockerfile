# Sử dụng Debian Slim
FROM node:20-bullseye-slim

# Cài đặt các công cụ build (Xóa chmod khỏi danh sách này vì nó có sẵn rồi)
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Cài đặt opencode-ai
RUN npm install -g opencode-ai

# Vẫn giữ lệnh chmod này vì nó dùng lệnh có sẵn trong hệ thống để sửa quyền file
RUN chmod +x /usr/local/lib/node_modules/opencode-ai/bin/.opencode

# Biến môi trường
ENV PORT=3000
ENV HOSTNAME=0.0.0.0

EXPOSE ${PORT}

# Sử dụng JSON format cho CMD theo khuyến nghị của Docker để xử lý tín hiệu tốt hơn
CMD ["sh", "-c", "opencode serve --port ${PORT} --hostname ${HOSTNAME}"]
