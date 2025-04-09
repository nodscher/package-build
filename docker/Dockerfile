FROM archlinux:latest

RUN echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
RUN pacman -Syu --noconfirm sudo base-devel git pacman-contrib python cron fish htop nano less
COPY makepkg.conf /etc/makepkg.conf
RUN sed -i "s/x86-64-placeholder/$(/lib/ld-linux-x86-64.so.2 --help | grep supported | awk 'FNR==1 {print$1}')/g" /etc/makepkg.conf

RUN useradd user -mG wheel && echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
WORKDIR /buildzone
RUN chown -R user:user /buildzone
USER user
COPY --chown=user:user build_pacman.sh build_pacman.sh
COPY --chown=user:user crontab crontab
COPY --chown=user:user server.sh server.sh
COPY --chown=user:user rm.sh rm.sh
RUN crontab crontab
RUN for f in build-linux-drm-tip-git build-linux-mainline build-mesa build-linux-amd build-linux-amd-drm-next; do ln -s build_pacman.sh "$f"; done

ENTRYPOINT ["./server.sh"]