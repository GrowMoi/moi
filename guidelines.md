# Guidelines

## branch, commit, pull request
(sí, en ese orden)

Si estás trabajando en una historia de usuario, te recomendamos crear un nuevo branch con el nombre de la historia de usuario en la que estás trabajando.

Ejemplo: `moi-amb-002`

Todos los commits que realices, los colocas dentro de tu nuevo branch y luego haces un [pull request](https://github.com/GrowMoi/moi/pulls/1) para que alguien más lo revise y lo una al branch principal (`master`).

Recuerda no hacer `merge` de tus propios pull requests a menos que sea un _hotfix_ y utilizar mensajes cortos.

Intenta colocar un enlace y el ID de la historia de usuario en la que estás trabajando dentro del Pull Request, así quien la revise entenderá mejor qué es lo que estás haciendo.

Haz un [squash](http://gitready.com/advanced/2009/02/10/squashing-commits-with-rebase.html) de los commits si tienes muchos de ellos en un sólo branch; idealmente el PR tiene un sólo commit.

## código
Te recomendamos utilizar [Sublime Text](http://www.sublimetext.com/) o [Atom](https://atom.io/). En ambos puedes activar dos preferencias *importantes*:
- Remover espacio en blanco de los archivos que editas. En SublimeText "trim_trailing_white_space_on_save": true
- Utilizar una línea nueva como delimitador de final de archivo. En SublimeText "ensure_newline_at_eof_on_save": true

De preferencia, el código que escribamos va a estar en inglés. Esto es solamente para hacerlo estándar y por si tenemos que integrar personas de un mercado global al equipo.
