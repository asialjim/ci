#!/bin/bash

# 帮助信息
help() {
    echo "可用命令及参数说明:"
    echo "build: 构建 maven 工程"
    echo "install: 安装 maven 工程到宿主机"
    echo "publish: 发布 maven 工程到中央仓库"
    echo "/bin/bash: 进入镜像/容器，并打开 bash"
    echo "sh: 用于执行脚本"
    echo "help: 显示此帮助信息"
    echo "release: 执行自动化发布脚本"
    echo "参数:"
    echo "  --repository <url>: 拉取 git 仓库，支持 ssh 和 http 方式"
    echo "  --ssh-key <path>: 指定使用宿主机 ssh 密钥对（目录），不传递则使用镜像默认密钥对"
    echo "  --git-username <username>: 指定 http git 仓库用户名"
    echo "  --git-password <password>: 指定 http git 仓库密码"
    echo "  --gpg-key <path>: 指定使用宿主机 gpg 密钥对（目录）"
}

# 拉取 git 仓库
clone_repo() {
    local repo=$1
    local ssh_key=$2
    local git_username=$3
    local git_password=$4

    if [ -n "$ssh_key" ]; then
        eval $(ssh-agent -s)
        ssh-add $ssh_key
    fi

    if [[ $repo == http* ]]; then
        if [ -n "$git_username" ] && [ -n "$git_password" ]; then
            git clone $repo
        else
            echo "使用 http 方式拉取仓库时，需要提供 --git-username 和 --git-password 参数"
            exit 1
        fi
    else
        git clone $repo
    fi
}

# 构建 maven 工程
build() {
    mvn clean package
}

# 安装 maven 工程到宿主机
install() {
    mvn clean install
}

# 发布 maven 工程到中央仓库
publish() {
    local gpg_key=$1
    if [ -n "$gpg_key" ]; then
        gpg --import $gpg_key/private.key
    fi
    mvn clean deploy
}

# 执行 release 脚本
release() {
    CURRENT_VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
    RELEASE_VERSION=${CURRENT_VERSION%-SNAPSHOT}
    NEW_VERSION=$(echo $RELEASE_VERSION | awk -F. '{$NF = $NF + 1; print $0}' | sed 's/ /./g')-SNAPSHOT
    mvn clean install
    mvn clean release:prepare -B -Prelease,!dev -DreleaseVersion=$RELEASE_VERSION -DdevelopmentVersion=$NEW_VERSION -DasialjimVersion=$RELEASE_VERSION
    mvn install
    mvn release:perform -B -DasialjimVersion=$RELEASE_VERSION
}

# 解析参数
while [[ $# -gt 0 ]]; do
    case "$1" in
        --repository)
            REPOSITORY="$2"
            shift 2
            ;;
        --ssh-key)
            SSH_KEY="$2"
            shift 2
            ;;
        --git-username)
            GIT_USERNAME="$2"
            shift 2
            ;;
        --git-password)
            GIT_PASSWORD="$2"
            shift 2
            ;;
        --gpg-key)
            GPG_KEY="$2"
            shift 2
            ;;
        *)
            COMMAND="$1"
            shift
            ;;
    esac
done

# 执行命令
case "$COMMAND" in
    build)
        if [ -n "$REPOSITORY" ]; then
            clone_repo $REPOSITORY $SSH_KEY $GIT_USERNAME $GIT_PASSWORD
        fi
        build
        ;;
    install)
        if [ -n "$REPOSITORY" ]; then
            clone_repo $REPOSITORY $SSH_KEY $GIT_USERNAME $GIT_PASSWORD
        fi
        install
        ;;
    publish)
        if [ -n "$REPOSITORY" ]; then
            clone_repo $REPOSITORY $SSH_KEY $GIT_USERNAME $GIT_PASSWORD
        fi
        publish $GPG_KEY
        ;;
    release)
        if [ -n "$REPOSITORY" ]; then
            clone_repo $REPOSITORY $SSH_KEY $GIT_USERNAME $GIT_PASSWORD
        fi
        release
        ;;
    /bin/bash)
        exec /bin/bash
        ;;
    sh)
        exec sh $@
        ;;
    help)
        help
        ;;
    *)
        echo "未知命令: $COMMAND"
        help
        exit 1
        ;;
esac