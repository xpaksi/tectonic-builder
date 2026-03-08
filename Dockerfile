FROM archlinux:base-devel

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm --needed git sudo

ARG AUR_USER=aur-user

RUN AUR_USER_HOME="/var/${AUR_USER}" && \
    useradd "${AUR_USER}" --system --shell /usr/bin/nologin --create-home --home-dir "${AUR_USER_HOME}" && \
    passwd --lock "${AUR_USER}" && \
    echo "${AUR_USER} ALL=(ALL) NOPASSWD: /usr/bin/pacman" > "/etc/sudoers.d/allow_${AUR_USER}_to_pacman" && \
    chmod 0440 "/etc/sudoers.d/allow_${AUR_USER}_to_pacman"

# Install yay from AUR
RUN AUR_USER_HOME="/var/${AUR_USER}" && \
    cd "${AUR_USER_HOME}" && \
    git clone https://aur.archlinux.org/yay.git && \
    chown -R "${AUR_USER}:${AUR_USER}" yay && \
    cd yay && \
    sudo -u "${AUR_USER}" makepkg -si --noconfirm && \
    cd .. && rm -rf yay

USER ${AUR_USER}

# Install tectonic-git
RUN yay -S --noconfirm tectonic-git && \
    yay -Scc --noconfirm && \
    rm -rf ~/.cache

# Install biber pin it into 2.17 since biblatex is 3.17 and texlive-latexextra
RUN sudo pacman -U --noconfirm --noprogressbar https://archive.archlinux.org/packages/b/biber/biber-1%3A2.17-2-any.pkg.tar.zst && \
    sudo pacman -S --noconfirm --needed --noprogressbar texlive-latexextra && \
    sudo pacman -Scc --noconfirm && \
    rm -rf ~/.cache
