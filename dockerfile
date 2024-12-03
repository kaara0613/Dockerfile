# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: kaara <kaara@student.42tokyo.jp>           +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/12/03 11:22:02 by kaara             #+#    #+#              #
#    Updated: 2024/12/03 18:18:27 by kaara            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


FROM --platform=linux/amd64 ubuntu:22.04

# 非対話型モードを設定
ENV DEBIAN_FRONTEND=noninteractive

# ARG for norminette version and branch
ARG NORM_VERSION=v3.3.51
ARG BRANCH_NAME=master

# パッケージの更新と必要なツールのインストール
RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y \
        gcc \
        g++ \
        clang \
        valgrind \
        git \
        curl \
        python3-pip \
        python3-venv \
        build-essential \
        dos2unix \
    && bash -c "$(curl -fsSL https://raw.github.com/xicodomingues/francinette/$BRANCH_NAME/bin/install.sh)" \
    && pip3 install norminette==$NORM_VERSION \
    && apt-get purge -y \
        curl \
        python3-pip \
        python3-venv \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリを設定
WORKDIR /app

# カレントディレクトリの内容をコンテナにコピー
COPY . /app

# スクリプトに実行権限を付与し、改行コードを修正
RUN	apt-get purge -y dos2unix && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# ENTRYPOINTを使用してスクリプトを実行
ENTRYPOINT ["/bin/bash"]

# ビルドと実行のためのコマンド（コメント）
# docker build --platform=linux/amd64 -t do_francinette .
# docker run --platform=linux/amd64 -it --rm do_francinette

#, "/app/entrypoint.sh"

# 実行コマンド
# docker build -t do_francinette .
# docker run -it --rm do_francinette

# norminette install
# python3 -m pip install --upgrade pip setuptools
# python3 -m pip install norminette
