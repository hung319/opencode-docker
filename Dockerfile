FROM debian:stable

# Copy uv binary từ image chính thức
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

# Cấu hình môi trường
ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/usr/local/bin:/usr/bin:${PATH}" \
    BUN_INSTALL="/usr" \
    XDG_DATA_HOME=/root/.local/share \
    NODE_ENV=production \
    PORT=4096

SHELL ["/bin/bash", "-c"]

# Cài đặt dependencies hệ thống, Node.js và Python
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    ssh \
    build-essential \
    tini \
    procps \
    unzip \
    psmisc \
    && curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && uv python install 3.12 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Cài đặt Bun và các package cần thiết
RUN curl -fsSL https://bun.sh/install | bash && \
    /usr/bin/bun install -g opencode-ai@latest @openchamber/web@latest

# Cấu hình tin cậy cho Bun
RUN echo -e "[install.trustedDependencies]\n\"*\" = true" > /root/.bunfig.toml

# Patch lỗi cache của opencode (giữ nguyên logic của bạn)
RUN if [ -f /usr/bin/opencode ]; then mv /usr/bin/opencode /usr/bin/opencode-original; fi && \
    cat <<'EOF' > /usr/bin/opencode && chmod +x /usr/bin/opencode
#!/bin/bash
rm -rf /root/.cache/opencode/package.json 2>/dev/null || true
exec /usr/bin/opencode-original "$@"
EOF

WORKDIR /root

# Port mặc định
EXPOSE 4096

# Sử dụng tini để quản lý signal (tránh zombie process) 
# Chạy trực tiếp lệnh bạn yêu cầu
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["opencode", "web", "--hostname", "0.0.0.0", "--port", "4096"]
