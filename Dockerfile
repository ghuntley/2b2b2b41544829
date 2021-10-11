FROM ubuntu:focal

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update \
      && apt-get install --no-install-recommends -y ca-certificates curl direnv docker git linux-image-$(uname -r) libguestfs-tools locales xz-utils qemu qemu-system-x86 vim zsh \
      && apt-get clean && rm -rf /var/lib/apt/lists/* \
      && mkdir -m 0755 /nix && groupadd -r nixbld && chown root /nix \
      && for n in $(seq 1 10); do useradd -c "Nix build user $n" -d /var/empty -g nixbld -G nixbld -M -N -r -s "$(command -v nologin)" "nixbld$n"; done
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -o pipefail && curl -L https://nixos.org/nix/install | bash
RUN echo ". $HOME/.nix-profile/etc/profile.d/nix.sh" >> ~/.zshrc

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

ENV USER=root

RUN chsh -s `which zsh`
RUN direnv hook zsh >> ~/.zshrc

RUN echo "PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# '" >> ~/.zshrc
