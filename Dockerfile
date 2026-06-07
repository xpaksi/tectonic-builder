FROM archlinux:base-devel

RUN pacman -Syu --noconfirm \
 && pacman -S --noconfirm --needed \
      wget \
      tar \
      git \
      texlive-latexextra \
      typst \
      tectonic \
      libxcrypt-compat \
 && pacman -Scc --noconfirm

RUN wget -O /tmp/biber.tar.gz \
    "https://sourceforge.net/projects/biblatex-biber/files/biblatex-biber/2.17/binaries/Linux/biber-linux_x86_64.tar.gz/download" \
 && tar -xzf /tmp/biber.tar.gz -C /tmp \
 && install -m755 /tmp/biber /usr/local/bin/biber \
 && rm -rf /tmp/biber*