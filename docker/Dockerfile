FROM archlinux:latest

RUN echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
RUN pacman -Syu --noconfirm sudo base-devel git pacman-contrib python cron fish htop nano
COPY makepkg.conf /etc/makepkg.conf
RUN sed -i "s/x86-64-placeholder/$(/lib/ld-linux-x86-64.so.2 --help | grep supported | awk 'FNR==1 {print$1}')/g" makepkg.conf

RUN useradd user -mG wheel && echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
WORKDIR /buildzone
RUN chown -R user:user /buildzone
USER user
COPY --chown=user:user build_pacman.sh build_pacman.sh
RUN mkdir log && ln -s build_pacman.sh build-linux-drm && ln -s build_pacman.sh build-linux-mainline && ln -s build_pacman.sh build-mesa

ENTRYPOINT ["/usr/bin/sudo", "crond", "-f"]