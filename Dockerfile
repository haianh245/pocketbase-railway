# --- PocketBase on Railway (Docker) ---
FROM alpine:3.20

ARG PB_VERSION=0.29.2

RUN apk add --no-cache ca-certificates wget unzip bash \
 && update-ca-certificates

WORKDIR /pb

# tải binary PB
RUN wget -q -O /tmp/pb.zip \
  https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip \
 && unzip /tmp/pb.zip -d /pb \
 && rm /tmp/pb.zip \
 && chmod +x /pb/pocketbase

# thư mục dữ liệu bền (sẽ mount Volume của Railway vào đây)
RUN mkdir -p /pb/pb_data

# Cấu hình CORS qua biến môi trường PB_ORIGINS
ENV PB_ORIGINS="*"

# Quan trọng: Railway cấp biến $PORT → lắng nghe đúng $PORT
# --dir /pb/pb_data: đảm bảo dữ liệu nằm ở volume
CMD ["/bin/sh","-lc","/pb/pocketbase serve --http=0.0.0.0:${PORT:-8080} --dir /pb/pb_data --origins \"${PB_ORIGINS}\""]
