# Vẫn dùng Debian Slim cho ổn định
FROM oven/bun:latest

# Thiết lập thư mục làm việc
WORKDIR /app

# Cài đặt trực tiếp opencode-ai vào container
# Bun sẽ tự tạo node_modules và các file cần thiết ở đây
RUN bun install opencode-ai

# Mở port cho web (mặc định thường là 3000)
EXPOSE 4096

# Chạy trực tiếp lệnh web của opencode
# Dùng 'bunx' để nó tự tìm lệnh 'opencode' trong thư mục vừa cài
CMD ["bunx", "opencode", "web", "--hostname", "0.0.0.0"]
