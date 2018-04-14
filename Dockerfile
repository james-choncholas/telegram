FROM phusion/baseimage:latest

ENV TELEGRAM_CLI=https://github.com/vysheng/tg.git
ENV NCTELEGRAM=https://github.com/Nanoseb/ncTelegram/blob/master/README.md

RUN echo "Installing dependancies" && \
    apt-get update && \
    apt-get install -y \
      git \
      sudo \
      libnotify-bin \
      caca-utils \
      python3-urwid \
      python3-psutil \
      python3-pip \
      libreadline-dev \
      libconfig-dev \
      libssl-dev \
      lua5.2 \
      liblua5.2-dev \
      libevent-dev \
      libjansson-dev \
      libpython-dev \
      make && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install --upgrade pip

RUN echo "Adding User anon" && \
    useradd --create-home --home-dir /home/anon --shell /bin/bash anon && \
    echo "anon:anon" | chpasswd && adduser anon sudo && \
    chown -R anon:anon /home/anon
USER anon
WORKDIR /home/anon

RUN echo "Installing Telegram CLI" && \
    cd && git clone --recursive $TELEGRAM_CLI && \
    cd tg && ./configure && make && \
    echo "anon\n" | sudo -S ln -s /home/anon/tg/bin/telegram-cli /usr/bin/telegram-cli && \
    echo "anon\n" | sudo -S mkdir /etc/telegram-cli && \
    echo "anon\n" | sudo -S ln -s /home/anon/tg/server.pub /etc/telegram-cli/server.pub && \
    echo "anon\n" | sudo -S chown -R anon:anon /etc/telegram-cli

RUN echo "Installing ngTelegram" && \
    echo "anon\n" | sudo -SE pip3 install --upgrade https://github.com/Nanoseb/ncTelegram/archive/master.tar.gz && \
    cp /etc/ncTelegram.conf ~/.ncTelegram.conf

COPY telegram.sh /usr/bin/
ENTRYPOINT ["telegram.sh"]
