FROM s10akir/moja-nvim

# Linuxでのroot:root問題対策
RUN chmod 777 /root

RUN chmod 777 /root/.cache
RUN chmod -R 777 /root/.cache/dein

RUN chmod 777 /root/.config
RUN chmod -R 777 /root/.config/nvim

RUN chmod 777 /root/.local/
RUN chmod 777 /root/.local/share
RUN chmod -R 777 /root/.local/share/nvim

ENTRYPOINT ["nvim"]
