#!/bin/bash
# entrypoint.sh

# 功能：处理 SSH 密钥挂载逻辑
setup_ssh() {
    if [ ! -d "/root/.ssh" ]; then
        # 未挂载宿主机目录时使用镜像自带密钥
        mkdir -p /root/.ssh
        cp -r /opt/.ssh/* /root/.ssh/
        chmod 700 /root/.ssh
        chmod 600 /root/.ssh/*
    fi
}

# 功能：处理 GPG 密钥挂载逻辑
setup_gpg() {
    if [ ! -d "/root/.gnupg" ]; then
        # 未挂载宿主机目录时使用镜像自带密钥
        mkdir -p /root/.gnupg
        cp -r /opt/.gnupg/* /root/.gnupg/
        chmod 700 /root/.gnupg
        chmod 600 /root/.gnupg/*
    fi
}

# 功能：处理 Git 仓库认证
setup_git_auth() {
    if [[ $REPO == http* ]]; then
        # HTTP 仓库认证处理
        if [ -n "$GIT_USERNAME" ] && [ -n "$GIT_PASSWORD" ]; then
            # 注入用户名密码到 git URL
            git config --global url."https://${GIT_USERNAME}:${GIT_PASSWORD}@${REPO#https://}".insteadOf "$REPO"
        fi
    else
        # SSH 仓库认证处理
        ssh-keyscan -t ed25519 $(echo $REPO | awk -F@ '{print $2}' | cut -d: -f1) >> /root/.ssh/known_hosts
    fi
}

# 功能：执行 Maven 命令
run_maven() {
    case $CMD in
        sh)
            /bin/bash
            ;;
        build)
            mvn clean package -DskipTests
            ;;
        install)
            mvn clean install -DskipTests
            ;;
        publish)
            mvn clean deploy -DskipTests
            ;;
        release)
            # 自动化发布逻辑
            CURRENT_VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
            RELEASE_VERSION=${CURRENT_VERSION%-SNAPSHOT}
            NEW_VERSION=$(echo $RELEASE_VERSION | awk -F. '{$NF = $NF + 1; print $0}' | sed 's/ /./g')-SNAPSHOT

            mvn clean install release:prepare -B -Prelease,!dev \
                -DreleaseVersion=$RELEASE_VERSION \
                -DdevelopmentVersion=$NEW_VERSION \
                -DasialjimVersion=$RELEASE_VERSION
            mvn install release:perform -B -DasialjimVersion=$RELEASE_VERSION
            ;;
        help|*)
            # 显示帮助信息
            echo "使用方法:"
            echo "  docker run [OPTIONS] IMAGE [COMMAND]"
            echo "命令:"
            echo "  build    构建项目：mvn clean package"
            echo "  install  安装项目：mvn clean install"
            echo "  publish  发布工件：mvn clean deploy"
            echo "  release  自动化发布流程"
            echo "  help     显示帮助信息"
            echo "参数:"
            echo "  -e CMD=           maven 命令"
            echo "      build    构建项目：mvn clean package"
            echo "      install  安装项目：mvn clean install"
            echo "      publish  发布工件：mvn clean deploy"
            echo "      release  自动化发布流程"
            echo "      help     显示帮助信息"
            echo "  -e REPO=          Git 仓库地址"
            echo "  -e GIT_USERNAME=  Git 用户名（HTTP 仓库需要）"
            echo "  -e GIT_PASSWORD=  Git 密码（HTTP 仓库需要）"
            echo "SSH 仓库构建"
            echo "docker run -it --rm -e REPO=git@github.com:user/repo.git -v ~/.ssh:/root/.ssh  -v ~/.m2:/root/.m2  asialjim/maven-with-gpg:jdk8  build "
            echo "docker run -it --rm -e REPO=https://github.com/user/repo.git -e GIT_USERNAME=yourname -e GIT_PASSWORD=yourpass -v ~/.gnupg:/root/.gnupg -v ~/.m2:/root/.m2  asialjim/maven-with-gpg:jdk8  publish"
            ;;
    esac
}

# 主执行流程
main() {
    # 初始化目录结构
    setup_ssh
    setup_gpg

    # 克隆代码仓库
    if [ -n "$REPO" ]; then
        git clone $REPO /app
        cd /app
    fi

    # 配置仓库认证
    setup_git_auth

    # 执行 Maven 命令
    if [ -n "$CMD" ]; then
        run_maven
    fi
}

# 启动主流程
main