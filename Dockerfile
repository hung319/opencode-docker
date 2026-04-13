# Sử dụng bản node nhẹ để tối ưu dung lượng image
FROM node:20-alpine

# Cài đặt các phụ thuộc hệ thống cần thiết (nếu opencode-ai cần build tool)
# Nếu không cần, bạn có thể xóa dòng RUN apk này
RUN apk add --no-cache python3 make g++

# Cài đặt toàn cục opencode-ai
RUN npm install -g opencode-ai

# Thiết lập các biến môi trường mặc định
ENV PORT=3000
ENV HOSTNAME=0.0.0.0

# Mở port (thông báo cho Docker biết container lắng nghe ở port nào)
EXPOSE ${PORT}

# Lệnh chạy ứng dụng sử dụng các biến ENV
# Sử dụng shell form để các biến ENV được thay thế chính xác
CMD opencode serve --port ${PORT} --hostname ${HOSTNAME}
