{ ... }:

{
  home.file = {
    ".gitconfig" = {
      force = true;
      text = ''
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
    };

  };
}
