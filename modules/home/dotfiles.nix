{ ... }:

{
  home.file = {
    ".gitconfig".text = ''
      [user]
      	email = e.todoruk@omp.ru
      	name = Eugene Todoruk
      [core]
      	editor = nvim
      [url "ssh://git@git.omprussia.ru"]
      	insteadof = https://git.omprussia.ru
      [url "ssh://git@os-git.omprussia.ru"]
      	insteadof = https://os-git.omprussia.ru
      [url "https://github.com"]
      	insteadof = git://github.com
      [pager]
      	diff = false
    '';

    ".ssh/config".text = ''
      Host laptop
      	HostName 192.168.88.24
      	User nighteugene

      Host aq
      	HostName 192.168.2.15
      	User root
      	StrictHostKeyChecking no
      	UserKnownHostsFile=/dev/null

      Host daq
      	HostName 192.168.2.15
      	User defaultuser
      	StrictHostKeyChecking no
      	UserKnownHostsFile=/dev/null

      Host work
      	HostName 10.190.30.5
      	User e.todoruk

      Host git.omprussia.ru
      	PreferredAuthentications publickey
      	AddKeysToAgent yes
      	IdentityFile ~/.ssh/id_ed25519
      	IgnoreUnknown WarnWeakCrypto
      	WarnWeakCrypto no-pq-kex

      Host os-git.omprussia.ru
      	PreferredAuthentications publickey
      	AddKeysToAgent yes
      	IdentityFile ~/.ssh/id_ed25519
      	IgnoreUnknown WarnWeakCrypto
      	WarnWeakCrypto no-pq-kex
    '';
  };
}
