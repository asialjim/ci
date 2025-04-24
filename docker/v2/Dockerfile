# 使用基础镜像
FROM maven:3.8.6-openjdk-8

# 安装 gpg 和 ssh
RUN apt-get update && apt-get install -y gnupg2 openssh-client && rm -rf /var/lib/apt/lists/*

# 生成 gpg 密钥对
RUN gpg --batch --gen-key <<EOF
%no-protection
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: Default GPG Key
Name-Email: default@example.com
Expire-Date: 0
EOF

# 发布公钥到服务器
RUN gpg --keyserver hkps://keyserver.ubuntu.com --send-keys $(gpg --list-secret-keys --keyid-format=long | grep sec | awk '{print $2}' | cut -d/ -f2)

# 导出 gpg 密钥对到宿主机
RUN mkdir -p /root/gpg-keys
RUN gpg --export -a > /root/gpg-keys/public.key
RUN gpg --export-secret-keys -a > /root/gpg-keys/private.key

# 生成 ssh 密钥对
RUN ssh-keygen -t ed25519 -N "" -C "Default Asial Jim API ssh Key" -f /root/.ssh/id_ed25519

# 导出 ssh 密钥对到宿主机
RUN mkdir -p /root/ssh-keys
RUN cp /root/.ssh/id_ed25519 /root/ssh-keys/
RUN cp /root/.ssh/id_ed25519.pub /root/ssh-keys/

# 复制脚本到容器内
COPY scripts/ /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# 工作目录
WORKDIR /app

# 定义入口点
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]