# Sử dụng Debian Slim để có đầy đủ glibc và sự ổn định
FROM node:20-bullseye-slim

# Cài đặt các công cụ cần thiết để build và chạy binary
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    chmod \
    && rm -rf /var/lib/apt/lists/*

# Cài đặt opencode-ai toàn cục
RUN npm install -g opencode-ai

# Sửa lỗi quyền thực thi (nếu có) trên Debian
RUN chmod +x /usr/local/lib/node_modules/opencode-ai/bin/.opencode

# Thiết lập biến môi trường mặc định
ENV PORT=3000
ENV HOSTNAME=0.0.0.0

# Mở port
EXPOSE ${PORT}

# Chạy ứng dụng
# Sử dụng shell form để ENV được nhận diện chính xác
CMD opencode serve --port ${PORT} --hostname ${HOSTNAME}
