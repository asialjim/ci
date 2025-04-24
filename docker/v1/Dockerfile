FROM maven:3.8.6-openjdk-8

# 安装依赖
RUN apt-get update && \
    apt-get install -y gnupg openssh-client && \
    rm -rf /var/lib/apt/lists/*

# 生成 GPG 密钥对
RUN mkdir -p /root/.gnupg && \
    gpg --batch --generate-key <<EOF
%no-protection
Key-Type: RSA
Key-Length: 2048
Subkey-Type: RSA
Subkey-Length: 2048
Name-Real: default asialjim docker api gpg
Name-Email: 714346043@qq.com
Expire-Date: 0
EOF

# 发布 GPG 公钥
RUN gpg --keyserver hkps://keyserver.ubuntu.com --send-keys $(gpg --list-keys --with-colons | awk -F: '/^pub:/ { print $5 }')

# 生成 SSH 密钥对
RUN ssh-keygen -t ed25519 -f /root/.ssh/id_ed25519 -q -N "" -C "Default Asial Jim API ssh Key"

# 创建密钥导出目录
RUN mkdir -p /export/gpg /export/ssh && \
    gpg --armor --export > /export/gpg/public.key && \
    gpg --armor --export-secret-keys > /export/gpg/private.key && \
    cp /root/.ssh/id_ed25519* /export/ssh/

# 复制脚本文件
COPY entrypoint.sh /entrypoint.sh
COPY release-script.sh /release-script.sh
RUN chmod +x /entrypoint.sh /release-script.sh

# 设置入口点
ENTRYPOINT ["/entrypoint.sh"]