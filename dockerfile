# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: kaara <kaara@student.42tokyo.jp>           +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/12/03 11:22:02 by kaara             #+#    #+#              #
#    Updated: 2024/12/14 23:02:43 by kaara            ###   ########.fr        #
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
		make \
		ssh \
		python3-pip \
		python3-venv \
		build-essential \
		dos2unix \
	&& pip3 install norminette==$NORM_VERSION \
	&& apt-get purge -y \
		curl \
		python3-pip \
		python3-venv \
	&& apt-get autoremove -y \
	&& apt-get clean -y \
	&& rm -rf /var/lib/apt/lists/* \
	&& git config --global user.name "kaara" \
	&& git config --global user.email "arakan0613@icloud.com"

# 作業ディレクトリを設定
WORKDIR /Desktop

# 必要に応じてファイルの改行コード変換を行い、最後にdos2unixを削除

# RUN dos2unix some_script.sh

RUN apt-get purge -y dos2unix && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# コンテナ起動時にbashを起動
CMD ["/bin/bash"]

# ビルドと実行コマンド
# docker build --platform=linux/amd64 -t ubuntu_22.04 .
# docker run --platform=linux/amd64 -it --rm -v ~/.ssh:/root/.ssh:ro ubuntu_22.04
