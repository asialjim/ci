# 使用官方 maven 镜像作为基础
FROM maven:3.8.6-openjdk-8

# 第一阶段：构建时配置
RUN apt-get update && \
    # 安装基础工具
    apt-get install -y gnupg openssh-client git && \
    # 清理缓存
    rm -rf /var/lib/apt/lists/*

# 配置 SSH 密钥
RUN mkdir -p /opt/.ssh && \
    # 生成 ED25519 密钥对
    ssh-keygen -t ed25519 -C "default asialjim docker api ssh key" -N "" -f /root/.ssh/id_ed25519 && \
    # 备份密钥到镜像目录
    cp /root/.ssh/id_ed25519* /opt/.ssh/ && \
    # 打印公钥到终端
    echo "生成的 SSH 公钥：" && cat /root/.ssh/id_ed25519.pub

# 配置 GPG 密钥
RUN mkdir -p /opt/.gnupg && \
    # 生成 GPG 密钥对（非交互模式）
    gpg --batch --generate-key <<EOF
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: asialjim_api_gpg
Name-Email: 714346047@qq.com
Expire-Date: 0
%no-protection
%commit
EOF
    # 备份密钥到镜像目录
RUN gpg --armor --export-secret-keys > /opt/.gnupg/private.key && \
    gpg --armor --export > /opt/.gnupg/public.key && \
    # 打印公钥到终端
    echo "生成的 GPG 公钥：" && gpg --armor --export && \
    # 上传公钥到服务器
    gpg --keyserver hkps://keyserver.ubuntu.com --send-keys $(gpg --list-secret-keys --keyid-format LONG | grep sec | awk '{print $2}' | cut -d '/' -f 2)

# 配置入口脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 定义容器启动点
ENTRYPOINT ["/entrypoint.sh"]